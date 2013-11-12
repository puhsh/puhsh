require 'spec_helper'

describe Badge do
  describe '.name' do
    let(:badge) { FactoryGirl.create(:badge, name: 'Test Badge') }

    it 'is required' do
      badge.name = nil
      badge.save
      expect(badge).to_not be_valid
    end
  end
end
