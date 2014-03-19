require 'spec_helper'

describe Invite do
  it { should belong_to(:user) }
  it { should have_one(:star) }

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

    it 'must be unique per user' do
      user = FactoryGirl.create(:user)
      invite = FactoryGirl.create(:invite, user: user, uid_invited: '123456')
      invite2 = FactoryGirl.build(:invite, user: user, uid_invited: '123456')
      invite2.save
      expect(invite2).to_not be_valid
    end

    it 'can be a duplicate for a different user' do
      user = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      invite = FactoryGirl.create(:invite, user: user, uid_invited: '123456')
      invite2 = FactoryGirl.build(:invite, user: user2, uid_invited: '123456')
      invite2.save
      expect(invite2).to be_valid
    end
  end

  describe '.create_multiple' do
    let(:user) { FactoryGirl.create(:user) }

    it 'creates a single invite' do
      invites = Invite.create_multiple([{user_id: user.id, uid_invited: '1234567'}])
      expect(user.reload.invites).to eql(invites)
    end

    it 'creates multiple invites' do
      invites = Invite.create_multiple([{user_id: user.id, uid_invited: '1234567'}, {user_id: user.id, uid_invited: '654321'}])
      expect(user.reload.invites).to eql(invites)
    end

    it 'creates multiple invites but does not return records with a nil id' do
      invites = Invite.create_multiple([{user_id: user.id, uid_invited: '1234567'}, {user_id: user.id, uid_invited: '7654321'}, {user_id: user.id, uid_invited: '1234567'}])
      expect(user.reload.invites.size).to eql(2)
      expect(invites.collect(&:id)).to_not include(nil)
    end
  end

  describe '.reward_stars' do
    it 'updates the user\'s star count' do
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:invite, user: user, uid_invited: '123456')
      FactoryGirl.create(:invite, user: user, uid_invited: '1234567')
      FactoryGirl.create(:invite, user: user, uid_invited: '1234568')
      expect(user.reload.star_count).to eql(19)
    end
  end
end
