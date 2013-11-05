require 'spec_helper'

describe V1::DevicesController do

  describe '#create' do
    let(:user) { FactoryGirl.create(:user) }
    let(:access_token) { FactoryGirl.create(:access_token, user: user) }
    let!(:device) { FactoryGirl.create(:device, user: user) }

    it 'does not create a device if there is no user' do
      post :create, format: :json
      expect(response).to_not be_success
    end

    it 'does not create a device if there is no device token' do
      sign_in user
      post :create, { access_token: access_token }, format: :json
      expect(response).to_not be_success
    end

    it 'does not create a device if there is no access token' do
      sign_in user
      post :create, { device_token: '1234' }, format: :json
      expect(response).to_not be_success
    end

    it 'does not create a device if there is an existing device' do
      sign_in user
      post :create, { user_id: user.id, device_token: device.device_token, access_token: access_token.token }, format: :json
      expect(assigns[:existing_devices]).to include(device)
      expect(response.body).to eql(assigns[:existing_devices].to_json)
    end

    it 'creates a device' do
      sign_in user
      post :create, { device_token: '12345', access_token: access_token.token }, format: :json
      expect(user.reload.devices).to include(assigns[:device])
    end
  end
end
