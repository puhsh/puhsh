require 'spec_helper'

describe PostsController do
  let!(:city) { FactoryGirl.create(:city) }
  let!(:user) { FactoryGirl.create(:user, home_city: city) }
  let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
  let!(:post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }
  let!(:item) { FactoryGirl.create(:item, post: post, price_cents: 1000) }

  context '#show' do
    it 'returns the post' do
      get :show, { city_id: city.id, user_id: user.id, id: post.id }, format: :html
      expect(assigns[:post]).to eql(post)
    end
  end
end
