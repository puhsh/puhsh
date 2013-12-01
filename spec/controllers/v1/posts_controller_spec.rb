require 'spec_helper'

describe V1::PostsController do

  describe '#show' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let!(:category) { FactoryGirl.create(:category) }
    let!(:subcategory) { FactoryGirl.create(:subcategory, category: Category.first) }
    let!(:post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }

    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        get :show, { id: post.id }, format: :json
        expect(assigns[:post]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        get :show, { id: post.id }, format: :json
        expect(assigns[:post]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let!(:access_token) { FactoryGirl.create(:access_token, user: user) }

      it 'finds the post' do
        sign_in user
        get :show, { id: post.id, access_token: access_token.token }, format: :json
        expect(assigns[:post]).to eql(post)
      end
    end
  end

  describe '#create' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let!(:category) { FactoryGirl.create(:category) }
    let!(:subcategory) { FactoryGirl.create(:subcategory, category: Category.first) }

    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        post :create, { post: { title: 'Test Post', description: 'Test Posting', pick_up_location: 'porch', payment_type: 'cash', subcategory: subcategory }}, format: :json
        expect(assigns[:post]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        post :create, { post: { title: 'Test Post', description: 'Test Posting', pick_up_location: 'porch', payment_type: 'cash', subcategory: subcategory }}, format: :json
        expect(assigns[:post]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let!(:access_token) { FactoryGirl.create(:access_token, user: user) }
      
      it 'creates a post' do
        sign_in user
        post :create, { post: { title: 'Test Post', description: 'Test Posting', pick_up_location: 'porch', payment_type: 'cash', category_id: category.id, subcategory_id: subcategory.id }, access_token: access_token.token }, format: :json
        expect(user.reload.posts).to include(assigns[:post])
      end

      it 'defaults to the current user' do
        sign_in user
        post :create, { post: { title: 'Test Post', description: 'Test Posting', pick_up_location: 'porch', payment_type: 'cash', category_id: category.id, subcategory_id: subcategory.id }, access_token: access_token.token }, format: :json
        expect(assigns[:post].user).to eql(user)
      end
    end
  end
end
