class Message < ActiveRecord::Base
  include Readable
  include Sortable
  attr_accessible :sender, :sender_id, :recipient, :recipient_id, :content

  # Relations
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'

  # Callbacks
  after_commit :send_new_message_email, on: :create
  after_commit :send_new_message_notification, on: :create
  
  # Validations
  validates :content, presence: true, length: { maximum: 160 }

  # Scopes
  scope :by_sender, ->(sender) { where(sender_id: sender.id) }
  scope :by_recipient, ->(recipient) { where(recipient_id: recipient.id) }
  scope :exclude_recipient, ->(recipient) { where('recipient_id != ?', recipient.id) }
  scope :grouped_by_recipient, group(:recipient_id)
  scope :between_sender_and_recipient, ->(sender, recipient) { where('(sender_id = ? and recipient_id = ?) or (sender_id = ? and recipient_id = ?)', sender, recipient, recipient, sender) } 
  scope :sent_or_received_by_user, ->(user) { where('sender_id = ? or recipient_id = ?', user, user) }
  scope :unread_count, ->(sender, recipient) { between_sender_and_recipient(sender, recipient).unread }

  # Methods
  def self.recent_conversations_for_user(user)
    query = Message.select('max(id)').group('greatest(sender_id, recipient_id)').group('least(sender_id, recipient_id)').to_sql
    Message.where("id in (#{query})").sent_or_received_by_user(user).newest
  end

  def notification_text
    "#{self.sender.first_name} just sent you a new message."
  end

  protected

  def send_new_message_email
    Puhsh::Jobs::EmailJob.send_new_message_email({message_id: self.id})
  end

  def send_new_message_notification
    Puhsh::Jobs::NotificationJob.send_new_message_notification({message_id: self.id})
  end

end
