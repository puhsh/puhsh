module Trackable
  extend ActiveSupport::Concern
  
  included do 
    after_commit :increment_create , on: :create
  end

  protected

  def increment_create
    if Rails.env.production?
      Puhsh::StatsdReporting.send_increment_to_statsd(self.class, 'create')
    end
  end
end
