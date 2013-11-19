require 'spec_helper'

describe Invite do
  it { should belong_to(:user) }

  let!(:invite) { FactoryGirl.build(:invite) }

  describe '.user' do
    it 'cannot be nil' do
      invite.uid_invited = '123456'
      invite.save
      expect(invite).to_not be_valid
    end
  end

  describe '.uid_invited' do
    it 'cannot be nil' do
      invite.user_id = 1
      invite.save
      expect(invite).to_not be_valid
    end

    it 'must be unique' do
      user = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      invite = FactoryGirl.create(:invite, user: user, uid_invited: '123456')
      invite2 = FactoryGirl.build(:invite, user: user2, uid_invited: '123456')
      invite2.save
      expect(invite2).to_not be_valid
    end
  end

  describe '.reward_stars' do
    it 'updates the user\'s star count' do
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:invite, user: user, uid_invited: '123456')
      expect(user.star_count).to eql(11)
    end
  end
end
