class Notification < ActiveRecord::Base
  include Readable
  attr_accessible :user, :user_id, :actor, :actor_id, :actor_type

  # Relations
  belongs_to :user
  belongs_to :actor, polymorphic: :true
  belongs_to :content, polymorphic: :true

  # Callbacks
  
  # Validations

  # Scopes
  scope :by_recipient, ->(recipient) { where(user_id: recipient.id) }
  scope :recent, order('created_at desc')
end
