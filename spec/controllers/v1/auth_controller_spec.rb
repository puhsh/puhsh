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
          user.merge!({'first_name' => 'test', 'last_name' => 'testlast', 'name' => 'test testlast','email' => 'test@test.local', 'verified' => 'true' })
          FacebookTestUser.create(fbid: user['id'])
          request.env['HTTP_AUTHORIZATION'] = user['access_token']

          expect(User).to receive(:find_verified_user).with(user['id'], request.env['HTTP_AUTHORIZATION']).and_return(user)
          post :create, { facebook_id: user['id'] }, format: :json
          test_users.delete(user)
        end
      end

      it 'finds an existing user' do
        VCR.use_cassette('/v1/auth/find_existing_user') do
          user = test_users.create(true)
          user.merge!({'first_name' => 'test', 'last_name' => 'testlast', 'name' => 'test testlast','email' => 'test@test.local', 'verified' => 'true' })
          FacebookTestUser.create(fbid: user['id'])
          puhsh_user = FactoryGirl.create(:user, uid: user['id'])

          request.env['HTTP_AUTHORIZATION'] = user['access_token']
          post :create, { facebook_id: user['id'] }, format: :json
          expect(assigns[:user]).to eql(puhsh_user)
        end
      end

      it 'generates an access token for existing user' do
        VCR.use_cassette('/v1/auth/token_existing_user') do
          user = test_users.create(true, {'verified' => true})
          puhsh_user = FactoryGirl.create(:user, uid: user['id'])
          FacebookTestUser.create(fbid: user['id'])

          request.env['HTTP_AUTHORIZATION'] = user['access_token']
          post :create, { facebook_id: user['id'] }, format: :json
          expect(assigns[:user].access_token).to_not be_nil
          expect(assigns[:user].access_token.expired?).to be_false
        end
      end

      it 'creates a new user' do
        VCR.use_cassette('/v1/auth/new_user') do
          user = test_users.create(true)
          user.merge!({'email' => 'test@test.local', 'verified' => 'true' })
          FacebookTestUser.create(fbid: user['id'])

          request.env['HTTP_AUTHORIZATION'] = user['access_token']
          post :create, { facebook_id: user['id'] }, format: :json
          expect(assigns[:user]).to eql(User.last)
        end
      end

      it 'creates an access token for a new user' do
        VCR.use_cassette('/v1/auth/token_new_user') do
          user = test_users.create(true)
          user.merge!({'first_name' => 'test', 'last_name' => 'testlast', 'name' => 'test testlast','email' => 'test@test.local', 'verified' => 'true' })
          FacebookTestUser.create(fbid: user['id'])

          request.env['HTTP_AUTHORIZATION'] = user['access_token']
          post :create, { facebook_id: user['id'] }, format: :json
          expect(assigns[:user].reload.access_token).to_not be_nil
          expect(assigns[:user].access_token.expired?).to be_false
        end
      end

      it 'stores the user\'s access token' do
        VCR.use_cassette('/v1/auth/store_fb_token') do
          user = test_users.create(true)
          user.merge!({'first_name' => 'test', 'last_name' => 'testlast', 'name' => 'test testlast','email' => 'test@test.local', 'verified' => 'true' })
          FacebookTestUser.create(fbid: user['id'])

          request.env['HTTP_AUTHORIZATION'] = user['access_token']
          post :create, { facebook_id: user['id'] }, format: :json
          expect(assigns[:user].reload.facebook_access_token.value).to eql(request.env['HTTP_AUTHORIZATION'])
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
