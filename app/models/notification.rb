class Notification < ActiveRecord::Base
  include Readable
  include Sortable
  include Trackable

  attr_accessible :user, :user_id, :actor, :actor_id, :actor_type, :content, :content_id, :content_type

  # Relations
  belongs_to :user
  belongs_to :actor, polymorphic: :true
  belongs_to :content, polymorphic: :true

  # Callbacks
  after_commit :increment_unread_count_for_user, on: :create
  before_save :decrement_unread_count_for_user
  
  # Validations

  # Scopes
  scope :by_recipient, ->(recipient) { where(user_id: recipient.id) }

  # Methods
  def self.fire!(user, content)
    Notification.new.tap do |notification|
      notification.user = user
      notification.actor = content.user
      notification.content = content
      notification.read = false
      notification.save
    end
  end

  protected

  def increment_unread_count_for_user
    if !self.read?
      User.update_counters self.user_id, unread_notifications_count: 1
    end
  end

  def decrement_unread_count_for_user
    if self.read && self.read_changed? && self.read_was == false && self.user.unread_notifications_count > 0
      User.update_counters self.user_id, unread_notifications_count: -1
    end
  end
end
