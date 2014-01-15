class Invite < ActiveRecord::Base
  include StarRewardable

  attr_accessible :user, :user_id, :uid_invited
  
  # Relations
  belongs_to :user

  # Callbacks
  
  # Validations
  validates :user_id, presence: true
  validates :uid_invited, presence: true, uniqueness: { scope: :user_id }

  def self.create_multiple(invites)
    return [] unless invites.present?
    create(invites).reject { |x| x.id.nil? }
  end
end
