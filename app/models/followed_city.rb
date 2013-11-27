class FollowedCity < ActiveRecord::Base
  attr_accessible :city_id, :city, :user_id, :user

  # Relations
  belongs_to :user
  belongs_to :city

  # Callbacks
  after_commit :store_city_id_for_user, on: :create
  before_destroy :remove_city_id_from_user

  # Validations
  validates :city_id, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true

  # Methods
  def self.create_multiple(followed_cities, user)
    return [] unless user
    followed_cities.each { |x| x.merge!({user_id: user.id}) }
    create(followed_cities).reject { |x| x.id.nil? }
  end

  protected

  def store_city_id_for_user
    self.user.followed_city_ids << self.city_id
  end

  def remove_city_id_from_user
    self.user.followed_city_ids.delete(self.city_id) if self.user.followed_city_ids.member?(self.city_id)
  end
end
