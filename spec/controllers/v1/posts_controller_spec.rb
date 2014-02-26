require 'spec_helper'

describe V1::PostsController do

  describe '#index' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let!(:user2) { FactoryGirl.create(:user, home_city: city) }
    let!(:category) { FactoryGirl.create(:category) }
    let!(:subcategory) { FactoryGirl.create(:subcategory, category: Category.first) }
    let!(:post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory, category: category) }
    let!(:post2) { FactoryGirl.create(:post, user: user2, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory, category: category) }

    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        get :index, { user_id: user.id }, format: :json
        expect(assigns[:posts]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        get :index, { user_id: user.id }, format: :json
        expect(assigns[:posts]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let!(:access_token) { FactoryGirl.create(:access_token, user: user) }
      let!(:access_token2) { FactoryGirl.create(:access_token, user: user2) }

      it 'returns the latest posts if no user is specified' do
        sign_in user
        get :index, { access_token: access_token.token }, format: :json
        expect(assigns[:posts]).to include(post)
        expect(assigns[:posts]).to include(post2)
      end

      it 'returns the specified users\'s posts' do
        sign_in user
        get :index, { user_id: user2.id, access_token: access_token.token }, format: :json
        expect(assigns[:posts]).to include(post2)
      end

      it 'does not return another user\'s posts' do
        sign_in user
        get :index, { user_id: user.id, access_token: access_token.token }, format: :json
        expect(assigns[:posts]).to_not include(post2)
      end

      it 'returns the category\'s posts' do
        sign_in user
        get :index, { category_id: category.id, access_token: access_token.token }, format: :json
        expect(assigns[:posts]).to include(post)
        expect(assigns[:posts]).to include(post2)
      end

      it 'returns the subcategory\'s posts' do
        sign_in user
        get :index, { subcategory_id: subcategory.id, access_token: access_token.token }, format: :json
        expect(assigns[:posts]).to include(post)
        expect(assigns[:posts]).to include(post2)
      end
    end

  end

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

      it 'creates a post and automatically assigns the category if one is not defined' do
        sign_in user
        post :create, { post: { title: 'Test Post', description: 'Test Posting', pick_up_location: 'porch', payment_type: 'cash', subcategory_id: subcategory.id }, access_token: access_token.token }, format: :json
        expect(assigns[:post].category).to eql(subcategory.category)
      end

      it 'defaults to the current user' do
        sign_in user
        post :create, { post: { title: 'Test Post', description: 'Test Posting', pick_up_location: 'porch', payment_type: 'cash', category_id: category.id, subcategory_id: subcategory.id }, access_token: access_token.token }, format: :json
        expect(assigns[:post].user).to eql(user)
      end

      it 'creates a free item associated with the post' do
        sign_in user
        post :create, { post: { title: 'Test Post', description: 'Test Posting', pick_up_location: 'porch', payment_type: 'cash', category_id: category.id, subcategory_id: subcategory.id, item_attributes: { price_cents: 0.00} }, access_token: access_token.token }, format: :json
        expect(assigns[:post].reload.item).to_not be_nil
      end

      it 'creates a paid item associated with the post' do
        sign_in user
        post :create, { post: { title: 'Test Post', description: 'Test Posting', pick_up_location: 'porch', payment_type: 'cash', category_id: category.id, subcategory_id: subcategory.id, item_attributes: { price_cents: 10.00} }, access_token: access_token.token }, format: :json
        expect(assigns[:post].reload.item).to_not be_nil
      end
    end
  end

  describe '#activity' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let!(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let!(:post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }
    let!(:item) { FactoryGirl.create(:item, post: post, price_cents: 1000) }
    let!(:offer) { FactoryGirl.create(:offer, item: item, post: post) }
    let!(:question) { FactoryGirl.create(:question, item: item, post: post, content: 'Test question') }

    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        get :activity, { id: post.id }, format: :json
        expect(assigns[:post]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        get :activity, { id: post.id }, format: :json
        expect(assigns[:post]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let!(:access_token) { FactoryGirl.create(:access_token, user: user) }

      it 'returns the activity for a post' do
        sign_in user
        get :activity, { id: post.id, access_token: access_token.token }, format: :json
        expect(assigns[:post].activity).to eql([offer, question])
      end
    end
  end
end
