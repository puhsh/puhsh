require 'spec_helper'

describe Device do
  let(:user) { FactoryGirl.create(:user) }

  describe '.device_id' do
    let(:device) { FactoryGirl.create(:device, user: user) }
    it 'is required' do
      device.device_id = nil
      device.save
      expect(device).to_not be_valid
    end
  end
end
