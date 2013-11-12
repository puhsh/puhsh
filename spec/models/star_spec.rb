require 'spec_helper'

describe Star do
  it { should belong_to(:user) }

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

  describe '.update_user_star_count' do
    it 'updates the user\'s star count' do
      star = FactoryGirl.create(:star, amount: 10, event: :new_account, user: user)
      expect(user.reload.star_count).to eql(20)
    end

    it 'updates the user\'s star count for negative values' do
      star = FactoryGirl.create(:star, amount: -5, event: :new_account, user: user)
      expect(user.reload.star_count).to eql(5)

    end
  end

end
