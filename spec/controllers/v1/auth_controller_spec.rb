require 'spec_helper'
require 'vcr_helper'

describe V1::AuthController do
  subject(:test_users) { Koala::Facebook::TestUsers.new(app_id: FACEBOOK_APP_ID, secret: FACEBOOK_APP_SECRET) }

  describe '#create' do
    context 'without FB access token' do
      it 'should be forbidden' do
        VCR.use_cassette('/v1/auth/no_access_token') do
          post :create, format: :json
          expect(response).to be_forbidden
        end
      end
    end

    context 'with valid FB access token' do
      it 'verifies the access token for a user' do
        VCR.use_cassette('/v1/auth/valid_access_token') do
          user = test_users.create(true)
          request.env['HTTP_AUTHORIZATION'] = user['access_token']

          post :create, { facebook_id: user['id'] }, format: :json
          expect(assigns[:facebook_record]).to_not be_nil
          expect(response).to be_success
          test_users.delete(user)
        end
      end
    end

    context 'with invalid FB access token' do
      it 'verifies the access token for a user' do
        VCR.use_cassette('/v1/auth/invalid_access_token') do
          user = test_users.create(true)
          request.env['HTTP_AUTHORIZATION'] = 'garbage_token'

          post :create, { facebook_id: user['id'] }, format: :json
          expect(assigns[:facebook_record]).to be_nil
          expect(response).to be_forbidden
          test_users.delete(user)
        end
      end
    end
  end
end
