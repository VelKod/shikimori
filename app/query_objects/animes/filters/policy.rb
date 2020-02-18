class Animes::Filters::Policy
  class << self
    FALSY = [false, 'false', 0, '0']
    ADULT_RATING_REGEXP =
      /(?:\A|,)(?:#{Types::Anime::Rating[:rx]}|#{Types::Anime::Rating[:r_plus]})\b/
    MUSIC_REGEXP = /(?:\A|,)#{Types::Anime::Kind[:music]}\b/

    HENTAI_GENRES_IDS = Genre::HENTAI_IDS + Genre::YAOI_IDS + Genre::YURI_IDS
    HENTAI_GENRES_REGEXP = /(?:\A|,)(?:#{HENTAI_GENRES_IDS.join '|'})\b/

    def exclude_hentai? params
      return false if forbid_filtering? params

      !adult_rating?(params[:rating]) && !hentai_genre?(params[:genre])
    end

    def exclude_music? params
      !music_kind?(params[:kind]) && !forbid_filtering?(params)
    end

  private

    def adult_rating? rating
      rating == Types::Anime::Rating[:rx] ||
        rating == Types::Anime::Rating[:r_plus] ||
        rating.is_a?(String) && rating.match?(ADULT_RATING_REGEXP)
    end

    def hentai_genre? genre
      genre.is_a?(String) && genre.match?(HENTAI_GENRES_REGEXP)
    end

    def music_kind? kind
      kind == Types::Anime::Kind[:music] ||
        kind.is_a?(String) && kind.match?(MUSIC_REGEXP)
    end

    def forbid_filtering? params # rubocop:disable all
      FALSY.include?(params[:censored]) ||
        params[:achievement].present? ||
        params[:franchise].present? ||
        params[:ids].present? ||
        params[:mylist].present? ||
        params[:publisher].present? ||
        params[:studio].present? ||
        params[:search].present? ||
        params[:q].present? ||
        params[:phrase].present?
    end
  end
end