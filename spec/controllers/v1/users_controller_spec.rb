require 'spec_helper'

describe V1::UsersController do

  describe '#show' do
    let(:user) { FactoryGirl.create(:user) }
    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        get :show, { id: user.id }, format: :json
        expect(assigns[:user]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        get :show, { id: user.id }, format: :json
        expect(assigns[:user]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let(:access_token) { FactoryGirl.create(:access_token, user: user) }
      it 'returns the user' do
        sign_in user
        get :show, { id: user.id, access_token: access_token.token }, format: :json
        expect(assigns[:user]).to eql(user)
      end
    end
  end

  describe '#create' do
    it 'is forbidden' do
      post :create, { user: { first_name: 'Test', last_name: 'Tester', name: 'Test Tester', uid: '12345678'} }, format: :json
      expect(response).to_not be_success
    end
  end

  describe '#update' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:city) { FactoryGirl.create(:city) }
    let!(:zipcode) { FactoryGirl.create(:zipcode, city_id: city.id) }
    let!(:new_york) { FactoryGirl.create(:city, name: 'New York City', state: 'NY') }
    let!(:ny_zipcode) { FactoryGirl.create(:nyc_zipcode, city_id: new_york.id) }

    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        put :update, { id: user.id, user: { zipcode: '123456' } }, format: :json
        expect(response).to_not be_success
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        put :update, { id: user.id, user: { zipcode: '123456' } }, format: :json
        expect(response).to_not be_success
      end
    end

    context 'with access token and authentication' do
      let(:access_token) { FactoryGirl.create(:access_token, user: user) }

      it 'updates the zipcode' do
        sign_in user
        put :update, { id: user.id, access_token: access_token.token, user: { zipcode: '75022' } }, format: :json
        expect(user.reload.zipcode).to eql('75022')
      end

      it 'updates the location description' do
        sign_in user
        put :update, { id: user.id, access_token: access_token.token, user: { location_description: 'near el dorado' } }, format: :json
        expect(user.reload.location_description).to eql('near el dorado')
      end

      it 'updates the contact email' do
        sign_in user
        put :update, { id: user.id, access_token: access_token.token, user: { contact_email: 'test@test.local' } }, format: :json
        expect(user.reload.contact_email).to eql('test@test.local')
      end

      it 'updates the home city' do
        sign_in user
        put :update, { id: user.id, access_token: access_token.token, user: { city_id: city.id } }, format: :json
        expect(user.reload.home_city).to eql(city)
      end

      it 'allows the user to update their home city from an existing one' do
        user.zipcode = zipcode.code
        user.home_city = city
        user.save
        sign_in user
        put :update, { id: user.id, access_token: access_token.token, user: { zipcode: ny_zipcode.code, city_id: new_york.id } }, format: :json
        expect(user.reload.home_city).to eql(new_york)
        expect(user.reload.zipcode).to eql(ny_zipcode.code)
      end
    end
  end

  describe '#destroy' do
    let(:user) { FactoryGirl.create(:user) }
    it 'is forbidden' do
      delete :destroy, { id: user.id }, format: :json
      expect(response).to_not be_success
    end
  end

  describe '#nearby_cities' do
    let(:user) { FactoryGirl.create(:user, zipcode: '75034') }
    let!(:city) { FactoryGirl.create(:city) }
    let!(:zipcode) { FactoryGirl.create(:zipcode, city_id: city.id) }

    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        get :nearby_cities, { id: user.id }, format: :json
        expect(assigns[:user]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        get :nearby_cities, { id: user.id }, format: :json
        expect(assigns[:user]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let(:access_token) { FactoryGirl.create(:access_token, user: user) }

      it 'returns cities' do
        get :nearby_cities, { id: user.id, access_token: access_token.token }, format: :json
        expect(assigns[:user].nearby_cities).to include(city)
      end
    end
  end

  describe '#activity' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:city2) { FactoryGirl.create(:city, name: 'New York City', state: 'NY') }
    let!(:zipcode) { FactoryGirl.create(:zipcode, city_id: city.id) }
    let!(:zipcode_nyc) { FactoryGirl.create(:nyc_zip, city_id: city2.id) }
    let!(:user) { FactoryGirl.create(:user) }
    let!(:user2) { FactoryGirl.create(:user) }
    let!(:user3) { FactoryGirl.create(:user) }
    let!(:category) { FactoryGirl.create(:category) }
    let!(:subcategory) { FactoryGirl.create(:subcategory, category: Category.first) }
    let!(:post) { FactoryGirl.create(:post, user: user2, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory, category: category) }

    before do
      user.zipcode = zipcode.code
      user.home_city = city
      user.save
      user2.zipcode = zipcode_nyc.code
      user2.home_city = city2
      user2.save
    end

    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        get :activity, { id: user.id }, format: :json
        expect(assigns[:posts]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        get :activity, { id: user.id }, format: :json
        expect(assigns[:posts]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let!(:access_token) { FactoryGirl.create(:access_token, user: user) }
      let!(:access_token2) { FactoryGirl.create(:access_token, user: user2) }

      it 'does not return any posts for cities the user is not following' do
        sign_in user
        get :activity, { id: user.id, access_token: access_token.token }, format: :json
        expect(assigns[:posts]).to_not include(post)
      end

      it 'does return any posts belonging to the current user' do
        post2 = FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory, category: category)
        sign_in user
        get :activity, { id: user.id, access_token: access_token.token }, format: :json
        expect(assigns[:posts]).to include(post2)
      end

      it 'does return posts for cities the user is following' do
        FollowedCity.create(user: user, city: city2)
        sign_in user
        get :activity, { id: user.id, access_token: access_token.token }, format: :json
        expect(assigns[:posts]).to include(post)
      end

      it 'returns posts from the users that the user is following' do
        FactoryGirl.create(:follow, user: user, followed_user: user3)
        post2 = FactoryGirl.create(:post, user: user3, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory, category: category)
        sign_in user
        get :activity, { id: user.id, access_token: access_token.token }, format: :json
        expect(assigns[:posts]).to include(post2)
      end

      it 'returns the posts from newest to oldest' do
        FollowedCity.create(user: user, city: city2)
        Timecop.travel(Date.today + 10.day) do
          post3 = FactoryGirl.create(:post, user: user2, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory, category: category)
          sign_in user
          get :activity, { id: user.id, access_token: access_token.token }, format: :json
          expect(assigns[:posts].map(&:id)).to eql([post3.id, post.id])
        end
      end

      it 'can exclude categories' do
        FollowedCity.create(user: user, city: city2)
        sign_in user
        get :activity, { id: user.id, access_token: access_token.token, without_category_ids: [post.category_id]}, format: :json
        expect(assigns[:posts]).to_not include(post)
      end

      it 'can exclude flagged posts' do
        FollowedCity.create(user: user, city: city2)
        FlaggedPost.create(user: user, post: post)
        sign_in user
        get :activity, { id: user.id, access_token: access_token.token, without_category_ids: [post.category_id]}, format: :json
        expect(assigns[:posts]).to_not include(post)
      end

      it 'can exclude sold posts' do
        FollowedCity.create(user: user, city: city2)
        post.status = :sold
        post.save
        sign_in user
        get :activity, { id: user.id, access_token: access_token.token, without_category_ids: [post.category_id]}, format: :json
        expect(assigns[:posts]).to_not include(post)
      end
    end
  end

  describe '#watched_posts' do
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let!(:user2) { FactoryGirl.create(:user, home_city: city) }
    let!(:category) { FactoryGirl.create(:category) }
    let!(:subcategory) { FactoryGirl.create(:subcategory, category: Category.first) }
    let!(:city) { FactoryGirl.create(:city) }
    let!(:post) { FactoryGirl.create(:post, user: user2, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory, category: category) }
    let!(:post2) { FactoryGirl.create(:post, user: user2, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory, category: category) }
    let!(:item) { FactoryGirl.create(:item, post: post, price_cents: 1000) }
    let!(:item2) { FactoryGirl.create(:item, post: post2, price_cents: 1000) }
    let!(:question) { FactoryGirl.create(:question, item: item, user: user, content: 'Is this item free?', post: post) }
    let!(:offer) { FactoryGirl.create(:offer, item: item2, user: user, amount_cents: 4000, post: post2) }

    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        get :watched_posts, { id: user.id }, format: :json
        expect(assigns[:posts]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        get :watched_posts, { id: user.id }, format: :json
        expect(assigns[:posts]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let!(:access_token) { FactoryGirl.create(:access_token, user: user) }

      it 'returns all posts the user has made an offer on or has asked a question on' do
        get :watched_posts, { id: user.id, access_token: access_token.token }, format: :json
        expect(assigns[:posts]).to include(post)
        expect(assigns[:posts]).to include(post2)
      end
    end
  end

  describe '#mutual_friends' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        get :mutual_friends, { id: user.id }, format: :json
        expect(assigns[:mutual_friends]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        get :mutual_friends, { id: user.id }, format: :json
        expect(assigns[:mutual_friends]).to be_nil
      end
    end
  end

  describe '#confirm' do
    let!(:user) { FactoryGirl.create(:user) }
    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        post :confirm, { id: user.id }, format: :json
        expect(assigns[:user]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        post :confirm, { id: user.id }, format: :json
        expect(assigns[:user]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let!(:access_token) { FactoryGirl.create(:access_token, user: user) }

      it 'sends the confirmation email' do
        sign_in user
        post :confirm, { id: user.id, access_token: access_token.token }, format: :json
        expect(response).to be_success
      end
    end
  end
end
