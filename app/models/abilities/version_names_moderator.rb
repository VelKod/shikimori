class Abilities::VersionNamesModerator
  include CanCan::Ability
  prepend Draper::CanCanCan

  MANAGED_FIELDS = %w[
    name
    russian
    english
    license_name_ru
    synonyms
    japanese
  ]
  MANAGED_MODELS = Abilities::VersionTextsModerator::MANAGED_MODELS

  def initialize _user
    can :sync, [Anime, Manga, Person, Character] do |entry|
      entry.mal_id.present?
    end

    can :manage, Version do |version|
      !version.is_a?(Versions::RoleVersion) &&
        version.item_diff &&
        (version.item_diff.keys & MANAGED_FIELDS).any? &&
        MANAGED_MODELS.include?(version.item_type)
    end
  end
end
