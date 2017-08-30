FactoryGirl.define do
  factory :user do
    sequence(:nickname) { |n| "user_#{n}" }
    sequence(:email) { |n| "email#{n}@factory.com" }
    password '123'
    last_online_at { Time.zone.now }
    sign_in_count 7

    can_vote_1 false
    can_vote_2 false
    can_vote_3 false

    notifications User::DEFAULT_NOTIFICATIONS

    locale 'ru'
    locale_from_host 'ru'

    after :build do |model|
      stub_method model, :create_history_entry
      stub_method model, :ensure_api_access_token
      stub_method model, :assign_style
      stub_method model, :send_welcome_message
      stub_method model, :grab_avatar

      stub_method model, :post_elastic
      stub_method model, :put_elastic
      stub_method model, :delete_elastic
    end

    trait :with_elasticserach do
      after :build do |model|
        unstub_method model, :post_elastic
        unstub_method model, :put_elastic
        unstub_method model, :delete_elastic
      end
    end

    trait :with_assign_style do
      after(:build) { |model| unstub_method model, :assign_style }
    end

    trait(:user) { sequence :id, 23_456_789 }
    trait(:guest) { id User::GUEST_ID }
    trait(:admin) { id User::ADMINS.last }
    trait(:moderator) { id User::MODERATORS.last }
    trait(:contests_moderator) { id User::CONTEST_MODERATORS.last }
    trait(:reviews_moderator) { id User::REVIEWS_MODERATORS.last }
    trait(:collections_moderator) { id User::COLLECTIONS_MODERATORS.last }
    trait(:video_moderator) { id User::VIDEO_MODERATORS.last }
    trait(:versions_moderator) { id User::VERSIONS_MODERATORS.last }
    trait(:banhammer) { id User::BANHAMMER_ID }
    trait(:cosplayer) { id User::COSPLAYER_ID }
    trait(:trusted_video_uploader) { id User::TRUSTED_VIDEO_UPLOADERS.last }
    trait(:trusted_version_changer) { id User::TRUSTED_VERSION_CHANGERS.last }
    trait(:api_video_uploader) { id User::API_VIDEO_UPLOADERS.last }

    trait :version_vermin do
      id User::VERSION_VERMINS.last
    end

    trait :without_password do
      password nil

      after :build do |user|
        user.stub(:password_required?).and_return false
      end
    end

    trait(:banned) { read_only_at { 1.year.from_now - 1.week } }
    trait(:forever_banned) { read_only_at { 1.year.from_now + 1.week } }
    trait(:day_registered) { created_at { 25.hours.ago } }
    trait(:week_registered) { created_at { 8.days.ago } }

    trait :with_avatar do
      avatar { File.new "#{Rails.root}/spec/files/anime.jpg" }
    end

    factory :cosplay_user, traits: [:cosplayer]
  end
end
