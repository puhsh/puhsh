module Trackable
  extend ActiveSupport::Concern
  
  included do 
    after_commit :increment_create , on: :create
  end

  protected

  def increment_create
    return unless Rails.env.production?
    case self
    when User
      Puhsh::StatsdReporting.send_increment_to_statsd(self.class, 'create')
      Puhsh::StatsdReporting.send_increment_to_statsd(self.class, "create_#{self.gender}")
    else
      Puhsh::StatsdReporting.send_increment_to_statsd(self.class, 'create')
    end
  end
end
