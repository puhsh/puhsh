class RelatedProduct
  include ActiveModel::Serialization

  attr_reader :api

  def initialize
    @api = Vacuum.new.configure(AMAZON_ADS_API_CONFIG)
  end

  def find_related_products(search_terms = nil, post_category_name = nil)
    if search_terms
      params = default_search_criteria.merge({'Keywords' => search_terms, 'SearchIndex' => search_index(post_category_name)})
      parsed_results(self.api.item_search(params))
    else
      {}
    end
  end

  def default_search_criteria
    {'SearchIndex' => search_index, 'Sort' => default_sort, 'ResponseGroup' => response_group}
  end

  def search_index(post_category_name = nil)
    amazon_category_mapping(post_category_name)
  end

  def default_sort
    'salesrank'
  end

  def response_group
    'Small,Images,ItemAttributes'
  end

  protected

  def parsed_results(response)
    response_hash = response.to_h
    items = response_hash['ItemSearchResponse']['Items']
    item = items['Item'].try(&:sample) unless response_hash.empty? || items['Item'].nil?

    if item
      { title: item['ItemAttributes'].try { |x| x['Title'] }, list_price: item['ItemAttributes'].try { |x| x['ListPrice'] }, url: item['DetailPageURL'], image_url: item['LargeImage'].try { |x| x['URL'] } }
    else
      {}
    end
  end

  # Protected: Maps a post's category name to a related category used in the Amazon Ad API
  #
  # post_category_name - The name of post's category. Defaults to nil
  #
  # Returns a string of Amazon specific categories
  def amazon_category_mapping(post_category_name = nil)
    case post_category_name
    when "Kid's Stuff"
      'Baby'
    when "Womens"
      'Apparel'
    when 'Sports'
      'SportingGoods'
    else
      'Baby'
    end
  end
end
