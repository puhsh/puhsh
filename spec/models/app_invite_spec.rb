require 'spec_helper'

describe AppInvite do
  it { should belong_to(:user) }

  let(:user) { FactoryGirl.create(:user) } 

  describe '.status' do
    let(:app_invite) { FactoryGirl.build(:app_invite) }

    it 'is required' do
      app_invite.status = nil
      app_invite.save
      expect(app_invite).to_not be_valid
    end

    it 'defaults to do inactive' do
      app_invite.save
      expect(app_invite.reload).to be_inactive
    end
  end

  describe '.activate!' do
    let(:app_invite) { FactoryGirl.create(:app_invite) }

    it 'activates the device' do
      app_invite.activate!
      expect(app_invite.reload).to be_active
    end
  end

  describe '.position' do
    let(:app_invite) { FactoryGirl.create(:app_invite) }
    let(:app_invite2) { FactoryGirl.create(:app_invite) }

    it 'gets the correct position' do
      expect(app_invite.position).to eq(1)
      expect(app_invite2.position).to eq(2)
    end
  end

  describe '.users_in_front_of_user' do
    let(:app_invite) { FactoryGirl.create(:app_invite) }
    let(:app_invite2) { FactoryGirl.create(:app_invite) }

    it 'determines number of users you are behind' do
      expect(app_invite.users_in_front_of_user).to eq(0)
      expect(app_invite2.users_in_front_of_user).to eq(1)
    end

    it 'updates when a user in front of the current user activates' do
      app_invite.activate!
      expect(app_invite2.users_in_front_of_user).to eq(0)
    end
  end

  describe '.current_position' do
    let(:app_invite) { FactoryGirl.create(:app_invite) }
    let(:app_invite2) { FactoryGirl.create(:app_invite) }
    let(:app_invite3) { FactoryGirl.create(:app_invite) }

    it 'calculates the current position properly' do
      expect(app_invite.current_position).to eql(1)
      expect(app_invite2.current_position).to eql(2)
      expect(app_invite3.current_position).to eql(3)
    end

    it 'updates the current position properly' do
      app_invite.activate!
      expect(app_invite2.current_position).to eql(1)
      expect(app_invite3.current_position).to eql(2)
    end
  end

end
