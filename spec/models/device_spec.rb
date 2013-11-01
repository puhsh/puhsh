require 'spec_helper'

describe Device do
  let(:user) { FactoryGirl.create(:user) }

  describe '.device_token' do
    let(:device) { FactoryGirl.create(:device, user: user) }
    it 'is required' do
      device.device_token = nil
      device.save
      expect(device).to_not be_valid
    end
  end

  describe '.fire_notification!' do
    let(:device) { FactoryGirl.create(:device, user: user) }

    it 'does not send a notification if there is no message' do
      expect(APN).to_not receive(:push)
      device.fire_notification!(nil)
    end

    it 'sends a push notification' do
      expect(APN).to receive(:push)
      device.fire_notification!("Test notification")
    end
  end
end
