class Device < ActiveRecord::Base
  attr_accessible :user, :device_token
  # Relations
  belongs_to :user

  # Callbacks

  # Validations
  validates :device_token, presence: true

  def fire_notification!(message)
    return unless message
    notification = Houston::Notification.new(device: self.device_token)
    notification.alert = message
    APN.push(notification)
  end

end
