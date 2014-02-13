class MessageConversationSerializer < ActiveModel::Serializer
  attributes :id,  :read, :created_at, :read_at, :unread_count

  has_one :sender, serializer: SimpleUserSerializer
  has_one :recipient, serializer: SimpleUserSerializer

  def unread_count
    object.class.unread_count(object.sender_id, object.recipient_id).count
  end
end
