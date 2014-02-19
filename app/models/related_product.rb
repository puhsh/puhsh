class RelatedProduct
  include ActiveModel::Serialization

  attr_reader :api

  def initialize
    @api = Vacuum.new.configure(YAML.load_file("#{Rails.root}/config/amazon-ads.yml")[Rails.env].symbolize_keys)
  end

  def find_related_products(search_terms = nil)
    if search_terms
      params = default_search_criteria.merge({'Keywords' => search_terms})
      parsed_results(self.api.item_search(params))
    else
      []
    end
  end

  def default_search_criteria
    {'SearchIndex' => search_index, 'Sort' => default_sort, 'ResponseGroup' => response_group}
  end

  def search_index
    'Baby'
  end

  def default_sort
    'salesrank'
  end

  def response_group
    'Small,Images,ItemAttributes'
  end

  protected

  def parsed_results(response)
    top_item = response.to_h['ItemSearchResponse']['Items']['Item'].first
    { title: top_item['ItemAttributes']['Title'], list_price: top_item['ItemAttributes']['ListPrice'], url: top_item['DetailPageURL'], image_url: top_item['LargeImage']['URL'] }
  end
end
