require 'spec_helper'

describe V1::FollowedCitiesController do
  let!(:city) { FactoryGirl.create(:city) }
  let!(:city2) { FactoryGirl.create(:city) }

  describe '#create' do
    let(:user) { FactoryGirl.create(:user) }
    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        get :index, { user_id: user.id }, format: :json
        expect(assigns[:followed_cities]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        get :index, { user_id: user.id }, format: :json
        expect(assigns[:followed_cities]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let(:access_token) { FactoryGirl.create(:access_token, user: user) }
      let!(:followed_city) { FactoryGirl.create(:followed_city, city: city, user: user) }

      it 'returns the user\'s followed cities' do
        sign_in user
        get :index, { user_id: user.id, access_token: access_token.token }, format: :json
        expect(user.reload.followed_cities).to eql(assigns[:followed_cities])
      end
    end
  end

  describe '#create' do
    let(:user) { FactoryGirl.create(:user) }
    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        post :create, { followed_cities: [{city_id: city.id}, {city_id: city2.id}]}, format: :json
        expect(assigns[:followed_cities]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        post :create, { followed_cities: [{city_id: city.id}, {city_id: city2.id}]}, format: :json
        expect(assigns[:followed_cities]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let(:access_token) { FactoryGirl.create(:access_token, user: user) }
      it 'creates a followed city' do
        sign_in user
        post :create, { followed_cities: [{city_id: city.id}], access_token: access_token.token }, format: :json
        expect(user.reload.followed_cities.collect(&:city_id)).to include(city.id)
      end

      it 'creates multiple followed cities' do
        sign_in user
        post :create, { followed_cities: [{city_id: city.id}, {city_id: city2.id}], access_token: access_token.token }, format: :json
        expect(user.reload.followed_cities.collect(&:city_id)).to include(city.id)
        expect(user.reload.followed_cities.collect(&:city_id)).to include(city2.id)
      end

      it 'creates followed cities but ignores duplicates' do
        sign_in user
        post :create, { followed_cities: [{city_id: city.id}, {city_id: city.id}], access_token: access_token.token }, format: :json
        expect(user.reload.followed_cities.collect(&:city_id)).to include(city.id)
        expect(user.reload.followed_cities.size).to eql(1)
      end
    end
  end
end
