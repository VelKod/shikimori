describe CalendarsQuery do
  let(:query) { CalendarsQuery.new }

  before do
    create :anime
    create :ongoing_anime, aired_on: Time.zone.now - 1.day
    create :ongoing_anime, duration: 20
    create :ongoing_anime, kind: 'ONA'
    create :ongoing_anime, episodes_aired: 0, aired_on: Time.zone.now - 1.day - 1.month
    create :anons_anime
    create :anons_anime
    create :anons_anime, aired_on: Time.zone.now + 1.week
  end

  it { query.send(:fetch_ongoings).should have(2).items }
  it { query.send(:fetch_anonses).should have(3).items }

  it { query.fetch.should have(4).items }
  it { query.fetch_grouped.should have(2).item }
end
