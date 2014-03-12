require 'spec_helper'

describe OpenGraphed do

  let!(:user) { FactoryGirl.create(:user) }

  describe '.facebook_access_token' do
    it 'stores the access token in redis' do
      user.facebook_access_token = '1234'
      expect(user.reload.facebook_access_token.value).to eql('1234')
    end

    it 'stores the expiration time in redis' do
      time = Time.now.to_i
      user.facebook_access_token_expires_at = time
      expect(user.reload.facebook_access_token_expires_at.value).to eql(time.to_s)
    end
  end

end
