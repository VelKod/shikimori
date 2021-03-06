class CalendarsQuery
  ONGOINGS_SQL = <<~SQL
    animes.broadcast is not null or
      (next_episode_at is not null and next_episode_at > (now() - interval '1 day')) or
      anime_calendars.episode is null or
      anime_calendars.episode = episodes_aired + 1
  SQL

  ANNOUNCED_FROM = 1.week
  ANNOUNCED_UNTIL = 1.month

  def fetch_grouped
    group fetch
  end

  def fetch
    entries = (fetch_ongoings + fetch_announced)
      .map { |anime| CalendarEntry.new(anime.decorate) }
      # .select { |v| v.id == 41_206 }

    exclude_overdue(
      entries
        .select(&:next_episode_start_at)
        .sort_by(&:next_episode_start_at)
    )
  end

  def cache_key
    [
      :calendar,
      AnimeCalendar.last.try(:id),
      Topics::NewsTopic.last.try(:id),
      Time.zone.today.to_s,
      :v4
    ]
  end

private

  def group entries
    entries = entries.group_by do |anime|
      # key_date = if anime.ongoing?
        # anime.next_episode_at || anime.episode_end_at ||
          # (anime.last_episode_date || anime.aired_on.to_datetime) + anime.average_interval
      # else
        # (anime.episode_end_at || anime.aired_on).to_datetime
      # end
      key_date = anime.next_episode_start_at

      if (key_date.to_i - Time.zone.now.to_i).negative?
        -1
      else
        (
          (
            key_date.to_i -
              Time.zone.now.to_i +
              60 * 60 * Time.zone.now.hour +
              60 * Time.zone.now.min
          ) * 1.0 / 60 / 60 / 24
        ).to_i
      end
    end
    Hash[entries.sort]
  end

  def fetch_ongoings
    Anime
      .includes(:episode_news_topics, :anime_calendars)
      .references(:anime_calendars)
      .where(status: :ongoing)
      .where(kind: %i[tv ona])
      .where.not(id: Anime::EXCLUDED_ONGOINGS + [15_547])
      .where(Arel.sql(ONGOINGS_SQL))
      .where(
        'episodes_aired != 0 or (aired_on is not null and aired_on > ?)',
        Time.zone.now - 1.months
      )
      .order(Arel.sql('animes.id'))
  end

  def fetch_announced
    Anime
      .includes(:episode_news_topics, :anime_calendars)
      .references(:anime_calendars)
      .where(status: :anons)
      .where(kind: %i[tv ona])
      .where.not(id: Anime::EXCLUDED_ONGOINGS)
      .where(
        "(
          anime_calendars.start_at is not null and
            start_at >= :from and
            start_at <= :to
        ) or (
          aired_on >= :from and
            aired_on <= :to and aired_on != :new_year
        )",
        from: ANNOUNCED_FROM.ago.to_date,
        to: ANNOUNCED_UNTIL.from_now.to_date,
        new_year: Time.zone.today.beginning_of_year.to_date
      )
      .where.not(
        Arel.sql(
          "anime_calendars.episode is null
          and date_part('day', aired_on) = 1
          and date_part('month', aired_on) = 1"
        )
      )
      .order(Arel.sql('animes.id'))
      # .where(Arel.sql("kind != 'ona' or anime_calendars.episode is not null"))
  end

  def exclude_overdue entries
    entries.select do |v|
      (v.next_episode_start_at && v.next_episode_start_at > Time.zone.now - 1.week) ||
        v.anons?
    end
  end
end
