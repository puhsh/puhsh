class Device < ActiveRecord::Base
  attr_accessible :user, :device_id
  # Relations
  belongs_to :user

  # Callbacks

  # Validations
  validates :device_id, presence: true
end
