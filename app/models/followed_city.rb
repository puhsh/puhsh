class FollowedCity < ActiveRecord::Base
  attr_accessible :city_id, :city, :user_id

  # Relations
  belongs_to :user
  belongs_to :city

  # Callbacks

  # Validations
  validates :city_id, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true

  def self.create_multiple(followed_cities, user)
    followed_cities.each { |x| x.merge!({user_id: user.id}) }
    create(followed_cities).reject { |x| x.id.nil? }
  end
end
