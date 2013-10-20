class City < ActiveRecord::Base
  geocoded_by :address
  
  # Relations
  has_many :followed_cities

  # Callbacks
end
