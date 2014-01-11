require 'spec_helper'

describe FlaggedPost do
  it { should belong_to(:post) } 
  it { should belong_to(:user) } 


  let(:city) { FactoryGirl.create(:city) }
  let(:zipcode) { FactoryGirl.create(:zipcode, city: city, code: '75033') }
  let(:user) { FactoryGirl.create(:user) }
  let(:post) { FactoryGirl.create(:post, user: user, city: city)  }

  context '.create' do
    let(:flagged_post) { FactoryGirl.build(:flagged_post, user: user, post: post) }

    it 'updates the flags count for posts' do
      flagged_post.save
      expect(post.reload.flags_count).to eq(1)
    end

    it 'updates the posts flagged count for users' do
      flagged_post.save
      expect(user.reload.posts_flagged_count).to eq(1)
    end

    it 'cannot be duplicated' do
      flagged_post.save
      flagged_post2 = FlaggedPost.create(user: user, post: post)
      expect(flagged_post2).to_not be_valid
    end
  end
end
