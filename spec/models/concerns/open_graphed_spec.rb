require 'spec_helper'
require 'vcr_helper'

describe OpenGraphed do
  subject(:test_users) { Koala::Facebook::TestUsers.new(app_id: FACEBOOK_APP_ID, secret: FACEBOOK_APP_SECRET) }

  let!(:user) { FactoryGirl.create(:user) }

  describe '.facebook_access_token' do
    it 'stores the access token in redis' do
      user.facebook_access_token = '1234'
      expect(user.reload.facebook_access_token.value).to eql('1234')
    end
  end

  describe '.facebook_access_token_expires_at' do
    it 'stores the expiration time in redis' do
      time = Time.now.to_i
      user.facebook_access_token_expires_at = time
      expect(user.reload.facebook_access_token_expires_at.value).to eql(time.to_s)
    end
  end

  describe '.find_verified_user' do
    it 'finds a verified user'do
      VCR.use_cassette('/models/concerns/open_graphed/verified_user') do
        user = test_users.create(true)
        FacebookTestUser.create(fbid: user['id'])

        expect(User.find_verified_user(user['id'], user['access_token'])).to_not be_nil
        test_users.delete(user)
      end
    end

    it 'does not find a verified user' do
      VCR.use_cassette('/models/concerns/open_graphed/non_verified_user') do
        user = test_users.create(true)
        expect(User.find_verified_user(user['id'], user['access_token'])).to be_nil
        test_users.delete(user)
      end
    end
  end

  describe '.store_facebook_access_token!' do
    it 'stores the token in redis' do
      user.store_facebook_access_token!('test')
      expect(user.reload.facebook_access_token.value).to eql('test')
    end
  end

  describe '.facebook_friends' do
    it 'returns your facebook friends from the open graph' do
      VCR.use_cassette('/models/concerns/open_graphed/facebook_friends') do
        fb_user = test_users.create(true)
        fb_user2 = test_users.create(true)
        test_users.befriend(fb_user, fb_user2)
        user.uid = fb_user['id']
        user.facebook_access_token = fb_user['access_token']
        user.facebook_access_token_expires_at = (Time.now + 1).to_i
        user.save

        expect(user.facebook_friends.map { |x| x['id'] }).to include(fb_user2['id'])
        test_users.delete(fb_user)
        test_users.delete(fb_user2)
      end
    end
  end
end
