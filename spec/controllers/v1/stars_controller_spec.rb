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
      let!(:star) { FactoryGirl.create(:star, user: user, amount: 10, reason: 'new_account') }

      it 'returns the stars' do
        sign_in user
        get :index, { user_id: user.id, access_token: access_token.token }, format: :json
        expect(assigns[:stars]).to include(star)
      end
    end
  end
end
