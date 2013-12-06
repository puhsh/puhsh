require 'spec_helper'

describe Device do
  it { should belong_to(:user) }

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
    context 'ios' do
      let(:device) { FactoryGirl.create(:device, device_type: :ios, device_token: "<faacd1a2 ca64c51c cddf2c3b cb9f52b3 40889c51 b6e641e1 fcb3a526 4d82e3e6>", user: user) }
      before do
        app = Rapns::Apns::App.new
        app.name = "puhsh_ios_development"
        app.certificate = File.read("#{Rails.root}/config/certs/puhsh_development.pem")
        app.environment = "development"
        app.connections = 1
        app.save!
      end

      it 'does not send a notification if there is no message' do
        expect(device.fire_notification!(nil, :test_event)).to eql(nil)
      end

      it 'does not send a notification if there is no event' do
        expect(device.fire_notification!('Test Notification', nil)).to eql(nil)
      end

      it 'sends a push notification' do
        expect(device.fire_notification!("Test notification", :test_event)).to eql(true)
      end
    end
  end
end
