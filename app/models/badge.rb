class Badge < ActiveRecord::Base
  attr_accessible :name

  # Relations

  # Callbacks
  
  # Validations
  validates :name, presence: true
end
