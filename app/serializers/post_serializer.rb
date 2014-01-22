class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :pick_up_location, :payment_type, :flags_count, :created_at, :category_name, :subcategory_name

  has_one :item
  has_one :city
  has_many :post_images
  has_one :user, serializer: PostUserSerializer

  def category_name
    object.category_name.value
  end

  def subcategory_name
    object.subcategory_name.value
  end
end
