class Zipcode < ActiveRecord::Base
  attr_accessible :city, :state, :latitude, :longitude, :code, :city_id, :city_name
  geocoded_by :address

  # Relations
  belongs_to :city

  # Callbacks
  
  # Validations
end
