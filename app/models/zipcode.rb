class Zipcode < ActiveRecord::Base
  geocoded_by :address

  # Relations
  belongs_to :city

  # Callbacks
  
  # Validations
end
