class PostSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :description, :pick_up_location, :payment_type, :flags_count, :created_at, :category_name, :subcategory_name, :status, :flagged_by_current_user, :url, :star_reward

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

  def url
    if object && object.city && object.user
      post_url(object.city.slug, object.user.slug, object.slug)
    end
  end

  def star_reward
    if object.new_record?
      object.star
    end
  end
end
