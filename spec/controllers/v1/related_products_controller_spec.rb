require 'spec_helper'

describe V1::RelatedProductsController do
  let!(:city) { FactoryGirl.create(:city) }
  let!(:user) { FactoryGirl.create(:user, home_city: city) }
  let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
  let!(:new_post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }

  let(:search_matcher) {
    lambda do |new_request, saved_request|
      new_keywords = new_request.uri[/Keywords=(.*)Operation=.*/, 1]
      saved_keywords = saved_request.uri[/Keywords=(.*)Operation=.*/, 1]
      new_keywords == saved_keywords
    end
  }

  context 'without access token' do
    it 'is forbidden' do
      sign_in user
      get :index, { post_id: new_post.id }
      expect(assigns[:related_product]).to be_nil
    end
  end

  context 'without authentication' do
    it 'is forbidden' do
      get :index, { post_id: new_post.id }
      expect(assigns[:related_product]).to be_nil
    end
  end

  context 'with access token and authentication' do
    let!(:access_token) { FactoryGirl.create(:access_token, user: user) }

    it 'returns related products' do
      VCR.use_cassette('/v1/posts/related_products', match_requests_on: [:method, search_matcher]) do
        sign_in user
        get :index, { post_id: new_post.id, access_token: access_token.token }
        expect(assigns[:related_product]).to_not be_nil
        expect(response).to be_success
      end
    end
  end
end
