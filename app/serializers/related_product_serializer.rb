class RelatedProductSerializer < ActiveModel::Serializer
  attributes :name, :price, :url, :image_urls, :currency, :retailer

  def name
    object.product['name']
  end

  def price
    object.price
  end

  def currency
    object.currency
  end

  def url
    object.product['url']
  end

  def image_urls
    object.product['images'].map { |x| x['ImageInfo'] }
  end

  def retailer
    object.location['retailer']
  end
end
