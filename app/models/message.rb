class Message < ActiveRecord::Base
  include Readable
  include Sortable
  attr_accessible :sender, :sender_id, :recipient, :recipient_id, :content

  # Relations
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'

  # Callbacks
  after_commit :send_new_message_email, on: :create
  
  # Validations
  validates :content, presence: true, length: { maximum: 160 }

  # Scopes
  scope :by_sender, ->(sender) { where(sender_id: sender.id) }
  scope :by_recipient, ->(recipient) { where(recipient_id: recipient.id) }
  scope :exclude_recipient, ->(recipient) { where('recipient_id != ?', recipient.id) }
  scope :grouped_by_recipient, group(:recipient_id)
  scope :between_sender_and_recipient, ->(sender, recipient) { where('(sender_id = ? and recipient_id = ?) or (sender_id = ? and recipient_id = ?)', sender, recipient, recipient, sender) } 

  # Methods

  protected

  def send_new_message_email
    Puhsh::Jobs::EmailJob.send_new_message_email({message_id: self.id})
  end
end
