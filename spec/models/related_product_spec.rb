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
      expect(related_product.find_related_products).to eql({})
    end

    it 'returns nothing if no match is found' do
      VCR.use_cassette('/models/related_product/search_amazon_no_results') do
        expect(related_product.find_related_products('1asafddsfasdf')).to eql({})
      end
    end

    it 'returns data from Amazon\'s API' do
      VCR.use_cassette('/models/related_product/search_amazon') do
        expect(related_product.find_related_products('Binky')).to_not eql({})
      end
    end
  end

end
