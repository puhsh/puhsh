require 'spec_helper'

describe V1::FollowsController do

  describe '#create' do
    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }

    context 'without access token' do
      it 'is forbidden' do
        sign_in user
        post :create, { follow: {followed_user_id: user2.id }}, format: :json
        expect(assigns[:follow]).to be_nil
      end
    end

    context 'without authentication' do
      it 'is forbidden' do
        post :create, { follow: {followed_user_id: user2.id }}, format: :json
        expect(assigns[:follow]).to be_nil
      end
    end

    context 'with access token and authentication' do
      let(:access_token) { FactoryGirl.create(:access_token, user: user) }
      it 'creates a follow record' do
        sign_in user
        post :create, { follow: {followed_user_id: user2.id }, access_token: access_token.token }, format: :json
        expect(user.reload.follows).to include(assigns[:follow])
        expect(user.following?(user2)).to be_true
      end
      
      it 'does not create duplicates' do
        Follow.create(user: user, followed_user: user2)
        sign_in user
        post :create, { follow: {followed_user_id: user2.id }, access_token: access_token.token }, format: :json
        expect(response).to_not be_success
        expect(user.reload.follows).to_not include(assigns[:follow])
      end
    end
  end
end
