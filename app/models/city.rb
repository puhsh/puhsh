class City < ActiveRecord::Base
  geocoded_by :address
  
  # Relations
  has_many :user_cities, dependent: :destroy
  has_many :users, through: :user_cities
  has_many :posts

  # Callbacks
end
