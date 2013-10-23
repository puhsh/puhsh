require 'spec_helper'

describe WaitingList do

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
end
