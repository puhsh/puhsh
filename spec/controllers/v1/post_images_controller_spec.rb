require 'spec_helper'

describe V1::PostImagesController do
  let!(:city) { FactoryGirl.create(:city) }
  let!(:user) { FactoryGirl.create(:user, home_city: city) }
  let!(:user2) { FactoryGirl.create(:user, home_city: city) }
  let!(:category) { FactoryGirl.create(:category) }
  let!(:subcategory) { FactoryGirl.create(:subcategory, category: Category.first) }
  let!(:new_post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory, category: category) }

  describe '#create' do
    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        post :create, { post_image: { } }, format: :json
        expect(assigns[:post_image]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        post :create, { post_image: { } }, format: :json
        expect(assigns[:post_image]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let!(:access_token) { FactoryGirl.create(:access_token, user: user) }

      it 'creates a post image' do
        sign_in user
        post :create, { post_image: { }, access_token: access_token.token }, format: :json
        expect(assigns[:post_image]).to be_valid
      end
    end
  end
end
