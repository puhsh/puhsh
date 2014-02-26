class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :actor, :content_type, :content, :read, :read_at, :created_at, :updated_at, :notification_text

  has_one :actor, serializer: SimpleUserSerializer

  def notification_text
    object.content.notification_text(object.actor)
  end
end
