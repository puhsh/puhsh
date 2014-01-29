class PostImageSerializer < ActiveModel::Serializer
  attributes :id, :post_id, :url

  def url
    object.image.url(:original)
  end
end