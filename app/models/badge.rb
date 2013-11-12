class Badge < ActiveRecord::Base
  attr_accessible :name

  # Relations
  has_many :user_badges
  has_many :users, through: :user_badges

  # Callbacks
  
  # Validations
  validates :name, presence: true

  def self.award!(badge_name, user)
    return unless badge_name && user
    badge = Badge.find_by_name(badge_name)
    if badge.present?
      badge.user_badges.create(user: user)
    end
  end
end
