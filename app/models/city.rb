class City < ActiveRecord::Base
  attr_accessible :state, :name

  # Relations
  has_many :users
  has_many :followed_cities
  has_many :users, through: :followed_cities
  has_many :posts
  has_many :zipcodes

  # Callbacks

  # Methods
  def follow!(user)
    FollowedCity.create({user: user, city: self})
  end
end
