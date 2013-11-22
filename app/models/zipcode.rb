class Zipcode < ActiveRecord::Base
  attr_accessible :city
  geocoded_by :address

  # Relations
  belongs_to :city

  # Callbacks
  
  # Validations
end
