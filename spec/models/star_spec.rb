require 'spec_helper'

describe Star do
  let(:user) { FactoryGirl.create(:user) }
  let(:star) { FactoryGirl.create(:star, amount: 10, event: :new_account, user: user) }

  describe '.event' do
    it 'is required' do
      star.event = nil
      star.save
      expect(star).to_not be_valid
    end
  end

  describe '.amount' do
    it 'is required' do
      star.amount = nil
      star.save
      expect(star).to_not be_valid
    end

    it 'can be positive' do
      star.amount = 100
      star.save
      expect(star.reload.amount).to eql(100)
    end

    it 'can be negative' do
      star.amount = -100
      star.save
      expect(star.reload.amount).to eql(-100)
    end
  end
end
