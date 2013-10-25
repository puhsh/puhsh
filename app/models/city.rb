class City < ActiveRecord::Base
  geocoded_by :address
  
  # Relations
  has_many :users
  has_many :followed_cities
  has_many :users, through: :followed_cities
  has_many :posts

  # Callbacks
end
