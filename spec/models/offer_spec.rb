require 'spec_helper'

describe Offer do
  it { should belong_to(:user) }
  it { should belong_to(:item) }

  let(:user) { FactoryGirl.create(:user) }
  let(:item) { FactoryGirl.create(:item) }
  let(:offer) { FactoryGirl.build(:offer, user: user, item: item) }

  context '.status' do
    it 'defaults to pending' do
      offer.save
      expect(offer.reload.status).to eq(:pending)
    end
  end

  context '.amount_cents' do
    it 'defaults to 0' do
      offer.save
      expect(offer.reload.amount_cents).to eq(0)
    end

    it 'can be set to a value' do
      offer.amount_cents = 1000
      offer.save
      expect(offer.reload.amount_cents).to eq(1000)
    end
  end

  context '.amount_currency' do
    it 'always is USD' do
      offer.amount_cents = 1000
      offer.save
      expect(offer.reload.amount_currency).to eq('USD')
    end
  end

  context '.free?' do
    it 'is true if amount_cents is 0' do
      offer.save
      expect(offer.reload.free?).to be_true
    end
  end
end
