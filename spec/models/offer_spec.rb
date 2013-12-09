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

    it 'can be set to accepted' do
      offer.status = :accepted
      offer.save
      expect(offer.reload.status).to eq(:accepted)
    end

    it 'can be set to rejected' do
      offer.status = :rejected
      offer.save
      expect(offer.reload.status).to eq(:rejected)
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

  context '.question' do
    it 'is not required' do
      offer.save
      expect(offer.reload).to be_valid
    end

    it 'can be provided' do
      offer.question = 'Is this item a test?'
      offer.save
      expect(offer.reload.question).to_not be_nil
    end
  end

  describe '.store_post_id_for_user' do
    let(:user) { FactoryGirl.create(:user) }
    let(:post) { FactoryGirl.create(:post, user: user) }
    let(:item) { FactoryGirl.create(:item, post: post) }

    it 'stores the post id in redis for the user' do
      offer = Offer.create(user: user, item: item)
      offer.run_callbacks(:commit)
      expect(user.reload.post_ids_with_offers.members).to include(post.id.to_s)
    end
  end

  describe '.store_offer_id_for_post' do
    let(:user) { FactoryGirl.create(:user) }
    let(:post) { FactoryGirl.create(:post, user: user) }
    let(:item) { FactoryGirl.create(:item, post: post) }

    it 'stores the offer id in redis for the post' do
      offer = Offer.create(user: user, item: item)
      expect(post.reload.offer_ids.members).to include(offer.id.to_s)
    end
  end
end
