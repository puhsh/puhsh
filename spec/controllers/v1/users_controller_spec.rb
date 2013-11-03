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
    let(:user) { FactoryGirl.create(:user) }
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
    end
  end

  describe '#destroy' do
    let(:user) { FactoryGirl.create(:user) }
    it 'is forbidden' do
      delete :destroy, { id: user.id }, format: :json
      expect(response).to_not be_success
    end
  end
end
