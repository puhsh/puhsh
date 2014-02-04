class Notification < ActiveRecord::Base
  include Readable

  # Relations
  belongs_to :user
  belongs_to :actor, polymorphic: :true
  belongs_to :content, polymorphic: :true

  # Callbacks
  
  # Validations

  # Scopes
  scope :by_recipient, ->(recipient) { where(user_id: recipient.id) }
end
