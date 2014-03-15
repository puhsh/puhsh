require 'spec_helper'

describe PostsController do
  let!(:city) { FactoryGirl.create(:city) }
  let!(:user) { FactoryGirl.create(:user, home_city: city) }
  let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
  let!(:post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }
  let!(:item) { FactoryGirl.create(:item, post: post, price_cents: 1000) }

  context '#show' do
    it 'returns the post if it can find one' do
      get :show, { city_id: city.id, user_id: user.id, id: post.id }, format: :html
      expect(assigns[:post]).to eql(post)
    end

    it '404s if it cannot find a user' do
      get :show, { city_id: city.id, user_id: 43234234234, id: post.id }, format: :html
      expect(response).to redirect_to 'http://www.puhsh.com/404'
    end

    it '404s if it cannot find a post tied to user' do
      get :show, { city_id: city.id, user_id: user.id, id: 2131231243234 }, format: :html
      expect(response).to redirect_to 'http://www.puhsh.com/404'
    end
  end
end
