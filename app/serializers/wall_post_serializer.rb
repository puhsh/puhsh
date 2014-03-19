class WallPostSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :post_type, :created_at, :updated_at, :star_reward

  def star_reward
    if object.new_record?
      object.star
    end
  end
end
