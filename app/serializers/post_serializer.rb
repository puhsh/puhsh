class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :pick_up_location, :payment_type, :flags_count, :created_at, :category_name, :subcategory_name, :status, :flagged_by_current_user

  has_one :item
  has_many :post_images
  has_one :user, serializer: SimpleUserSerializer

  def category_name
    object.category_name.value
  end

  def subcategory_name
    object.subcategory_name.value
  end

  def flagged_by_current_user
    object.flagged_by?(current_user)
  end
end
