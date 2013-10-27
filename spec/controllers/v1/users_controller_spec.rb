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
end
