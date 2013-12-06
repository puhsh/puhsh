class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :pick_up_location, :payment_type, :flags_count, :created_at, :user

  has_many :items
  has_many :post_images

  def user
    object.user
  end
end
