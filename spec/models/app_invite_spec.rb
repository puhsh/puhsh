require 'spec_helper'

describe AppInvite do
  let(:user) { FactoryGirl.create(:user) } 

  describe '.device_id' do
    let(:app_invite) { FactoryGirl.build(:app_invite) }

    it 'is required' do
      app_invite.device_id = nil
      app_invite.save
      expect(app_invite).to_not be_valid
    end
  end

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

  describe '.devices_in_front_of_current_device' do
    let(:app_invite) { FactoryGirl.create(:app_invite) }
    let(:app_invite2) { FactoryGirl.create(:app_invite) }

    it 'determines number of devices you are behind' do
      expect(app_invite.devices_in_front_of_current_device).to eq(0)
      expect(app_invite2.devices_in_front_of_current_device).to eq(1)
    end

    it 'updates when a device in front of the current device activates' do
      app_invite.activate!
      expect(app_invite2.devices_in_front_of_current_device).to eq(0)
    end
  end

end
