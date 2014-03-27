class RelatedProductSerializer < ActiveModel::Serializer
  attributes :name, :price, :url, :image_urls, :currency, :retailer

  def name
    object.name
  end

  def price
    object.msrp
  end

  def currency
    object.msrp_currency
  end

  def url
    object.url
  end

  def image_urls
    object.images
  end

  def retailer
    object.location.retailer
  end
end
