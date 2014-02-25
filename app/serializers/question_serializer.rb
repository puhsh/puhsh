class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :updated_at, :user, :item_id, :post_id

  has_one :user, serializer: SimpleUserSerializer
end
