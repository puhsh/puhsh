class Device < ActiveRecord::Base
  attr_accessible :user, :device_token, :device_type
  symbolize :device_type, in: [:android, :ios], methods: true, scopes: false, validate: false

  # Relations
  belongs_to :user

  # Callbacks

  # Validations
  validates :device_token, presence: true

  def fire_notification!(message, event)
    if self.android? && message
      self.send_gcm_notification(message)
    elsif self.ios? && message && event
      self.send_apn_notification(message, event)
    else
      nil
    end
  end

  protected

  def apn_app_name
    case self.device_type
    when :ios
      Rails.env.production? ? 'puhsh_ios' : "puhsh_ios_development"
    when :android
      Rails.env.production? ? 'puhsh_android' : "puhsh_android_development"
    else
      nil
    end
  end

  def send_apn_notification(message, event)
    n = Rapns::Apns::Notification.new
    n.app = Rapns::Apns::App.find_by_name(apn_app_name)
    n.device_token = self.device_token
    n.badge = 1
    n.alert = message
    n.attributes_for_device = { event => true }
    n.save!
  end

  def send_gcm_notification(message)
    n = Rapns::Gcm::Notification.new
    n.app = Rapns::Gcm::App.find_by_name(apn_app_name)
    n.registration_ids = [self.device_token]
    n.data = { message: message }
    n.save!
  end
end
