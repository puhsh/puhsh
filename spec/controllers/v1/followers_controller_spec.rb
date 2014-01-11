require 'spec_helper'

describe V1::FollowersController do
  describe '#index' do
    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }

    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        get :index, { user_id: user.id }, format: :json
        expect(assigns[:followers]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        get :index, { user_id: user.id }, format: :json
        expect(assigns[:followers]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let(:access_token) { FactoryGirl.create(:access_token, user: user) }
      before { Follow.create(user: user2, followed_user: user) }
      before { Follow.create(user: user, followed_user: user2) }

      it 'returns the current user\'s followers' do
        sign_in user
        get :index, { access_token: access_token.token }, format: :json
        expect(assigns[:followers]).to include(user2)
      end

      it 'returns a user\'s followers if a user id is specified' do
        sign_in user
        get :index, { user_id: user2.id, access_token: access_token.token }, format: :json
        expect(assigns[:followers]).to include(user)
      end
    end
  end
end
