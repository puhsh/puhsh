require 'spec_helper'

describe V1::CitiesController do
  let!(:city) { FactoryGirl.create(:city) }
  let!(:city2) { FactoryGirl.create(:city) }
  let!(:zipcode) { FactoryGirl.create(:zipcode, city: city) }

  describe '#index' do
    let(:user) { FactoryGirl.create(:user) }
    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        get :index, { user_id: user.id }, format: :json
        expect(assigns[:cities]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        get :index, { user_id: user.id }, format: :json
        expect(assigns[:cities]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let(:access_token) { FactoryGirl.create(:access_token, user: user) }
      let!(:followed_city) { FactoryGirl.create(:followed_city, city: city, user: user) }
      before { followed_city.run_callbacks(:commit) }

      it 'returns the user\'s followed cities' do
        sign_in user
        get :index, { user_id: user.id, access_token: access_token.token }, format: :json
        expect(assigns[:cities]).to include(city)
      end

      it 'finds the zipcode if a zipcode id is passed in' do
        get :index, { zipcode_id: zipcode.code, access_token: access_token.token }, format: :json
        expect(assigns[:cities]).to include(city)
      end
    end
  end
end
