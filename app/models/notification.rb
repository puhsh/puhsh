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

end
