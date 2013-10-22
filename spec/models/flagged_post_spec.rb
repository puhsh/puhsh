require 'spec_helper'

describe FlaggedPost do
  it { should belong_to(:post) } 
  it { should belong_to(:user) } 

  let(:city) { FactoryGirl.create(:city) }
  let(:user) { FactoryGirl.create(:user) }
  let(:post) { FactoryGirl.create(:post, user: user, city: city)  }

  context '.create' do
    let(:flagged_post) { FactoryGirl.build(:flagged_post, user: user, post: post) }

    it 'updates the flags count for posts' do
      flagged_post.save
      expect(post.reload.flags_count).to eq(1)
    end
  end
end
