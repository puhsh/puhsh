require 'spec_helper'

describe CitiesController do
  let!(:city) { FactoryGirl.create(:city) }
  let!(:city2) { FactoryGirl.create(:city) }
  let!(:user) { FactoryGirl.create(:user, home_city: city) }
  let!(:user2) { FactoryGirl.create(:user, home_city: city2) }
  let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
  let!(:post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }
  let!(:post2) { FactoryGirl.create(:post, user: user2, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }
  let!(:item) { FactoryGirl.create(:item, post: post, price_cents: 1000) }

  context '#show' do
    it 'finds the city' do
      get :show, { city_name: city.name, name: city.full_state_name }, format: :html
      expect(assigns[:city]).to eql(city)
    end

    it 'finds the posts in the city' do
      get :show, { city_name: city.name, name: city.full_state_name }, format: :html
      expect(assigns[:posts]).to include(post)
    end

    it 'does not find the posts that are not in the city' do
      get :show, { city_name: city.name, name: city.full_state_name }, format: :html
      expect(assigns[:posts]).to_not include(post2)
    end
  end
end
