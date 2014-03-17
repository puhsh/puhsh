require 'spec_helper'

describe ApplicationHelper do

  describe '.facebook_avatar_url' do
    let(:user) { FactoryGirl.create(:user, avatar_url: 'http://graph.facebook.com/1/picture?type=square') }

    it 'returns the stored url if an invalid size is used' do
      expect(facebook_avatar_url(user, :bad_size)).to eql(user.avatar_url)
    end

    it 'returns the stored url if a non symbol size is used' do
      expect(facebook_avatar_url(user, 'bad_size')).to eql(user.avatar_url)
    end

    it 'returns the stored url if no size is specified' do
      expect(facebook_avatar_url(user)).to eql(user.avatar_url)
    end

    it 'returns the new url if a valid size is specified' do
      expect(facebook_avatar_url(user, :normal)).to eql('http://graph.facebook.com/1/picture?type=normal')
    end
  end
end
