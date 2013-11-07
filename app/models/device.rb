class Device < ActiveRecord::Base
  attr_accessible :user, :device_token
  # Relations
  belongs_to :user

  # Callbacks

  # Validations
  validates :device_token, presence: true

  def fire_notification!(message)
    return unless message
  end

end
