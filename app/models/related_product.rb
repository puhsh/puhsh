class RelatedProduct
  include ActiveModel::Serialization

  attr_reader :api

  def initialize
    @api = Vacuum.new.configure(AMAZON_ADS_API_CONFIG)
  end

  def find_related_products(search_terms = nil, post_category_name = nil, post_subcategory_name = nil)
    if search_terms
      params = default_search_criteria.merge({'Title' => search_terms, 'SearchIndex' => search_index(post_category_name, post_subcategory_name)})
      parsed_results(self.api.item_search(params))
    else
      {}
    end
  end

  def default_search_criteria
    {'SearchIndex' => search_index, 'Sort' => default_sort, 'ResponseGroup' => response_group}
  end

  def search_index(post_category_name = nil, post_subcategory_name = nil)
    amazon_category_mapping(post_category_name, post_subcategory_name)
  end

  def default_sort
    'salesrank'
  end

  def response_group
    'Small,Images,ItemAttributes,OfferSummary'
  end

  protected

  def parsed_results(response)
    response_hash = response.to_h
    items = response_hash['ItemSearchResponse']

    if response_hash && response_hash['ItemSearchResponse']
      items = response_hash['ItemSearchResponse']['Items']
      item = items['Item'].try(&:sample)
    end

    if item.present? && item['ItemAttributes'].present?
      if item['OfferSummary'].present?
        { 
          title: item['ItemAttributes'].try { |x| x['Title'] }, lowest_price: item['OfferSummary']['LowestNewPrice'], 
          list_price: item['ItemAttributes'].try { |x| x['ListPrice'] }, url: item['DetailPageURL'], image_url: item['LargeImage'].try { |x| x['URL'] } 
        }
      else
        { 
          title: item['ItemAttributes'].try { |x| x['Title'] }, lowest_price: item['ItemAttributes'].try { |x| x['ListPrice'] }, 
          list_price: item['ItemAttributes'].try { |x| x['ListPrice'] }, url: item['DetailPageURL'], image_url: item['LargeImage'].try { |x| x['URL'] } 
        }
      end
    else
      {}
    end
  end

  # Protected: Maps a post's category name to a related category used in the Amazon Ad API
  #
  # post_category_name - The name of post's category. Defaults to nil
  #
  # Returns a string of Amazon specific categories
  def amazon_category_mapping(post_category_name = nil, post_subcategory_name = nil)
    case post_category_name
    when "Kids Stuff"
      if post_subcategory_name
        amazon_category_mapping_to_kids_subcategories(post_subcategory_name)
      else
        'Baby'
      end
    when "Womens"
      if post_subcategory_name
        amazon_category_mapping_to_womens_subcategories(post_subcategory_name)
      else
        'Apparel'
      end
    when 'Sports'
      if post_subcategory_name
        amazon_category_mapping_to_sports_subcategories(post_subcategory_name)
      else
        'SportingGoods'
      end
    else
      'All'
    end
  end

  def amazon_category_mapping_to_kids_subcategories(post_subcategory_name)
    if ['Lots & Multiple Items', 'Misc & Other'].include?(post_subcategory_name)
      'All'
    elsif post_subcategory_name == 'Shoes'
      'Shoes'
    elsif post_subcategory_name == 'Toys & Games'
      'Toys'
    else 
      'Baby'
    end
  end

  def amazon_category_mapping_to_womens_subcategories(post_subcategory_name)
    if post_subcategory_name == 'Jewelry'
      'Jewelry'
    elsif post_subcategory_name == 'Makeup & Fragrance'
      'Beauty'
    elsif post_subcategory_name == 'Shoes & Boots'
      'Shoes'
    else
      'Apparel'
    end
  end

  def amazon_category_mapping_to_sports_subcategories(post_subcategory_name)
    if post_subcategory_name == 'Other'
      'All'
    else 
      'SportingGoods'
    end
  end
end
