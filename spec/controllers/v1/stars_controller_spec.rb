require 'spec_helper'

describe V1::StarsController do

  describe '#index' do
    let(:user) { FactoryGirl.create(:user) }

    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        get :index, { user_id: user.id }, format: :json
        expect(assigns[:stars]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        get :index, { user_id: user.id }, format: :json
        expect(assigns[:stars]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let(:access_token) { FactoryGirl.create(:access_token, user: user) }
      let!(:star) { FactoryGirl.create(:star, user: user, amount: 10, event: 'new_account') }

      it 'returns the stars' do
        sign_in user
        get :index, { user_id: user.id, access_token: access_token.token }, format: :json
        expect(assigns[:stars]).to include(star)
      end
    end
  end

  describe '#create' do
    let(:user) { FactoryGirl.create(:user) }

    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        post :create, { user_id: user.id }, format: :json
        expect(assigns[:star]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        post :create, { user_id: user.id }, format: :json
        expect(assigns[:star]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let(:access_token) { FactoryGirl.create(:access_token, user: user) }

      it 'creates a star' do
        sign_in user
        post :create, { star: { user_id: user.id, amount: 10, event: 'friend_invite' }, access_token: access_token.token }, format: :json
        expect(user.reload.stars).to include(assigns[:star])
      end

      it 'does not create a star with a bad event' do
        sign_in user
        post :create, { star: { user_id: user.id, amount: 10, event: 'friend_invite_error' }, access_token: access_token.token }, format: :json
        expect(user.reload.stars).to_not include(assigns[:star])
      end

      it 'does not create a star with no amount' do
        sign_in user
        post :create, { star: { user_id: user.id, amount: nil, event: 'friend_invite' }, access_token: access_token.token }, format: :json
        expect(user.reload.stars).to_not include(assigns[:star])
      end

    end
  end
end
