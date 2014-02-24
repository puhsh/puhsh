module Trackable
  extend ActiveSupport::Concern
  
  included do 
    after_commit :increment_create , on: :create
  end

  protected

  def increment_create
    if Rails.env.production?
      Puhsh::StatsdReporting.increment_create(self.class, 'create')
    end
  end
end
