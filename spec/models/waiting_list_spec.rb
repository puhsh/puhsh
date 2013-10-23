require 'spec_helper'

describe WaitingList do
  let(:user) { FactoryGirl.create(:user) } 

  describe '.device_id' do
    let(:waiting_list) { FactoryGirl.build(:waiting_list) }

    it 'is required' do
      waiting_list.device_id = nil
      waiting_list.save
      expect(waiting_list).to_not be_valid
    end
  end

  describe '.status' do
    let(:waiting_list) { FactoryGirl.build(:waiting_list) }

    it 'is required' do
      waiting_list.status = nil
      waiting_list.save
      expect(waiting_list).to_not be_valid
    end

    it 'defaults to do inactive' do
      waiting_list.save
      expect(waiting_list.reload).to be_inactive
    end
  end

  describe '.activate!' do
    let(:waiting_list) { FactoryGirl.create(:waiting_list) }

    it 'activates the device' do
      waiting_list.activate!
      expect(waiting_list.reload).to be_active
    end
  end

  describe '.position' do
    let(:waiting_list) { FactoryGirl.create(:waiting_list) }
    let(:waiting_list2) { FactoryGirl.create(:waiting_list) }

    it 'gets the correct position' do
      expect(waiting_list.position).to eq(1)
      expect(waiting_list2.position).to eq(2)
    end
  end

  describe '.devices_in_front_of_current_device' do
    let(:waiting_list) { FactoryGirl.create(:waiting_list) }
    let(:waiting_list2) { FactoryGirl.create(:waiting_list) }

    it 'determines number of devices you are behind' do
      expect(waiting_list.devices_in_front_of_current_device).to eq(0)
      expect(waiting_list2.devices_in_front_of_current_device).to eq(1)
    end

    it 'updates when a device in front of the current device activates' do
      waiting_list.activate!
      expect(waiting_list2.devices_in_front_of_current_device).to eq(0)
    end
  end

end
