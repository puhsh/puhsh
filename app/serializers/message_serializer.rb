class MessageSerializer < ActiveModel::Serializer
  attributes :id, :content, :read, :created_at, :read_at

  has_one :sender, serializer: SimpleUserSerializer
  has_one :recipient, serializer: SimpleUserSerializer
end
