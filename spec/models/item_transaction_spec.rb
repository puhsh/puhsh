require 'spec_helper'
require 'vcr_helper'

describe ItemTransaction do
  it { should belong_to(:seller) }
  it { should belong_to(:buyer) }
  it { should belong_to(:post) }
  it { should belong_to(:item) }
  it { should belong_to(:offer) }


  describe '.send_item_purchased_email' do
    let(:user) { FactoryGirl.create(:user, contact_email: nil) }
    let(:user2) { FactoryGirl.create(:user, contact_email: nil) }
    let(:post) { FactoryGirl.create(:post, user: user) }
    let(:item) { FactoryGirl.create(:item, post: post) }
    let(:offer) { FactoryGirl.create(:offer, post: post, item: item, user: user2) }
    let(:offer2) { FactoryGirl.build(:offer, post: post, item: item) }

    before { ResqueSpec.reset! }

    it 'sends a item purchased email to the buyer' do
      offer.awarded!
      expect(Puhsh::Jobs::EmailJob).to have_queued(:send_item_purchased_email, {post_id: post.id, user_id: user2.id}).in(:email)
      expect_any_instance_of(Puhsh::Jobs::EmailJob).to receive(:send_item_purchased_email).with({'post_id' => post.id, 'user_id' => user2.id})
      ResqueSpec.perform_all(:email)
    end

    it 'does not send a item purchased email to the buyer if the item was sold offline' do
      offer2.awarded!
      expect(Puhsh::Jobs::EmailJob).to_not have_queued(:send_item_purchased_email, {post_id: post.id, user_id: user2.id}).in(:email)
      expect_any_instance_of(Puhsh::Jobs::EmailJob).to_not receive(:send_item_purchased_email).with({'post_id' => post.id, 'user_id' => user2.id})
      ResqueSpec.perform_all(:email)
    end
  end
end
