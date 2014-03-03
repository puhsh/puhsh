require 'spec_helper'

describe Offer do
  it { should belong_to(:user) }
  it { should belong_to(:item) }
  it { should belong_to(:post) }
  it { should have_one(:item_transaction) }

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

  describe '.store_post_id_for_user' do
    let(:user) { FactoryGirl.create(:user) }
    let(:post) { FactoryGirl.create(:post, user: user) }
    let(:item) { FactoryGirl.create(:item, post: post) }

    it 'stores the post id in redis for the user' do
      offer = Offer.create(user: user, item: item, post: post)
      offer.run_callbacks(:commit)
      expect(user.reload.post_ids_with_offers.members).to include(post.id.to_s)
    end
  end

  describe '.item_sold!' do
    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:post) { FactoryGirl.create(:post, user: user) }
    let(:item) { FactoryGirl.create(:item, post: post) }
    let(:offer) { FactoryGirl.create(:offer, post: post, item: item, user: user2) }

    it 'does not generate a transaction if called' do
      offer.item_sold!
      expect(offer.reload.item_transaction).to be_nil
    end
  end

  describe '.generate_item_transaction_record' do
    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:post) { FactoryGirl.create(:post, user: user) }
    let(:item) { FactoryGirl.create(:item, post: post) }
    let(:offer) { FactoryGirl.create(:offer, post: post, item: item, user: user2) }

    it 'generates the transaction record if the item was awarded to a buyer' do
      offer.awarded!
      expect(offer.reload.item_transaction).to_not be_nil
    end

    it 'does not generate a transaction record if it is not awarded' do
      offer.accepted!
      expect(offer.reload.item_transaction).to be_nil
    end

    it 'does not generate a second transaction record if the offer is awarded already' do
      offer.awarded!
      transaction = offer.reload.item_transaction
      expect(offer.reload.item_transaction).to_not be_nil
      offer.awarded!
      expect(offer.reload.item_transaction).to eql(transaction)
    end

    it 'sets the sold on time' do
      offer.awarded!
      expect(offer.reload.item_transaction.sold_on).to_not be_nil
    end
  end
end
