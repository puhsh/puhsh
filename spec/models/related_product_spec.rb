require 'spec_helper'
require 'vcr_helper'

describe RelatedProduct do
  let(:related_product) { RelatedProduct.new }

  describe '.api' do
    it 'should not be nil' do
      expect(related_product.api).to_not be_nil
    end
  end

  describe '.search_index' do
    it 'is only Baby related items' do
      expect(related_product.search_index).to eql 'Baby'
    end
  end

  describe '.default_sort' do
    it 'sorts on sales rank' do
      expect(related_product.default_sort).to eql 'salesrank'
    end
  end

  describe '.response_group' do
    it 'returns small information, images, and item attributes' do
      expect(related_product.response_group).to eql 'Small,Images,ItemAttributes'
    end
  end

  describe '.default_search_criteria' do
    it 'has default search criteria' do
      expect(related_product.default_search_criteria).to eql({"SearchIndex"=>"Baby", "Sort"=>"salesrank", "ResponseGroup"=>"Small,Images,ItemAttributes"})
    end
  end

  describe '.find_related_products' do
    it 'returns nothing if no terms are provided' do
      expect(related_product.find_related_products).to eql([])
    end

    it 'returns data from Amazon\'s API' do
      VCR.use_cassette('/models/related_product/search_amazon') do
        expect(related_product.find_related_products('Binky')).to eql({:title=>"Philips 2 Pack AVENT Soothie Pacifier, Pink/Purple, 0-3 Months", :list_price=>{"Amount"=>"645", "CurrencyCode"=>"USD", "FormattedPrice"=>"$6.45"}, :url=>"http://www.amazon.com/Philips-Soothie-Pacifier-Purple-Months/dp/B0045I6IA4%3FSubscriptionId%3DAKIAIO4ZPZLNHU3QUX5A%26tag%3Dpuhsh-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB0045I6IA4", :image_url=>"http://ecx.images-amazon.com/images/I/41V5jgei17L.jpg"})
      end
    end
  end

end
