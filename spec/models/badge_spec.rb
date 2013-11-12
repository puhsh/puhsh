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

  describe '.award!' do
    let!(:badge) { FactoryGirl.create(:badge, name: 'Test Badge') }
    let(:user) { FactoryGirl.create(:user) }

    it 'does not reward if no user is provided' do
      Badge.award!('Test Badge', nil)
      expect(user.reload.badges).to be_empty
    end

    it 'does not reward if no badge name is provided' do
      Badge.award!(nil, user)
      expect(user.reload.badges).to be_empty
    end

    it 'rewards a user with a badge' do
      Badge.award!('Test Badge', user)
      expect(user.reload.badges).to include(badge)
    end
  end
end
