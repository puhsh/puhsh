require 'spec_helper'

describe Offer do
  it { should belong_to(:user) }
  it { should belong_to(:item) }

  let(:user) { FactoryGirl.create(:user) }
  let(:item) { FactoryGirl.create(:item) }

  context '.status' do
    let(:offer) { FactoryGirl.build(:offer, user: user, item: item) }

    it 'defaults to pending' do
      offer.save
      expect(offer.reload.status).to eq(:pending)
    end
  end
end
