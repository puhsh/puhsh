class Event < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :resource, polymorphic: true

  # Callbacks

  # Validations
  validates :user, presence: true
  validates :resource, presence: true
  validates :controller_name, presence: true
  validates :controller_action, presence: true
  
  # Methods
end
