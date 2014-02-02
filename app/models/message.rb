class Message < ActiveRecord::Base
  attr_accessible :sender, :sender_id, :recipient, :recipient_id

  # Relations
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'

  # Callbacks
  
  # Validations
  validates :content, presence: true, length: { maximum: 160 }

  # Scopes
end
