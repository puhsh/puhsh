class Device < ActiveRecord::Base
  attr_accessible :user, :device_token
  # Relations
  belongs_to :user

  # Callbacks

  # Validations
  validates :device_token, presence: true

  def fire_notification!(message, event)
    return unless message && event && device_valid?
    n = Rapns::Apns::Notification.new
    n.app = Rapns::Apns::App.find_by_name(apn_app_name)
    n.device_token = self.device_token
    n.alert = message
    n.attributes_for_device = { event => true }
    n.save!
  end

  protected

  def apn_app_name
    Rails.env.production? ? 'puhsh' : "puhsh_development"
  end

  def device_valid?
    failed_device = Rapns::Apns::Feedback.find_by_device_token(self.device_token)
    if failed_device.present?
      self.destroy
      false
    else
      true
    end
  end
end
