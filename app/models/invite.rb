class Invite < ActiveRecord::Base
  attr_accessible :user, :user_id, :uid_invited
  
  # Relations
  belongs_to :user

  # Callbacks
  after_create :reward_stars
  
  # Validations
  validates :user_id, presence: true
  validates :uid_invited, presence: true, uniqueness: true

  protected

  def reward_stars
    Star.create(user: self.user, amount: 1, event: :friend_invite)
  end
end
