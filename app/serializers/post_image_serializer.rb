class PostImageSerializer < ActiveModel::Serializer
  attributes :id, :post_id, :url, :image_urls

  def url
    object.image.url(:medium)
  end

  def image_urls
    object.image_urls
  end
end
