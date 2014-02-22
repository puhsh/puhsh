class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :user, :actor_type, :actor, :content_type, :content, :read, :read_at, :created_at, :updated_at
end
