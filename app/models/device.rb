class Device < ActiveRecord::Base
  include Trackable
  attr_accessible :user, :device_token, :device_type
  symbolize :device_type, in: [:android, :ios], methods: true, scopes: :shallow, validate: false

  # Relations
  belongs_to :user

  # Callbacks
  after_create :add_app_invite

  # Validations

  def fire_notification!(message, event)
    begin
      if self.android? && message
        self.send_gcm_notification(message)
      elsif self.ios? && message && event
        self.send_apn_notification(message, event)
      else
        nil
      end
    rescue
      nil
    end
  end

  protected

  def apn_app_name
    "puhsh_#{self.device_type.to_s}_#{Rails.env}"
  end

  def send_apn_notification(message, event)
    n = Rpush::Apns::Notification.new
    n.app = Rpush::Apns::App.find_by_name(apn_app_name)
    n.device_token = self.device_token
    n.badge = self.user.unread_notifications_count
    n.alert = message
    n.attributes_for_device = { event => true }
    n.save!
  end

  def send_gcm_notification(message)
    n = Rpush::Gcm::Notification.new
    n.app = Rpush::Gcm::App.find_by_name(apn_app_name)
    n.registration_ids = [self.device_token]
    n.data = { message: message }
    n.save!
  end

  def add_app_invite
    if self.android?
      user.add_app_invite!
    end
  end
end
