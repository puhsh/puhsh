class RelatedProduct
  include ActiveModel::Serialization

  attr_reader :api

  def initialize
    @api = Vacuum.new.configure(YAML.load_file("#{Rails.root}/config/amazon-ads.yml")[Rails.env].symbolize_keys)
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
    item = response.to_h['ItemSearchResponse']['Items']['Item'].try(&:sample)
    if item
      { title: item['ItemAttributes']['Title'], list_price: item['ItemAttributes']['ListPrice'], url: item['DetailPageURL'], image_url: item['LargeImage']['URL'] }
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
    else
      'Baby'
    end
  end
end
