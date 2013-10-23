require 'spec_helper'

describe Post do
  it { should belong_to(:user) }
  it { should have_many(:items) }
  it { should belong_to(:city) }
  it { should have_many(:flagged_posts) }

  let(:user) { FactoryGirl.create(:user) }

  describe '.create' do
    let(:post) { FactoryGirl.build(:post) }

    it 'updates the user\'s post count' do
      post.user = user
      post.save
      expect(user.reload.posts_count).to eq(1)
    end
  end

  describe '.title' do
    let(:post) { FactoryGirl.build(:post, description: 'Foo bar') }

    it 'is required' do
      post.title = nil
      post.save
      expect(post).to_not be_valid
    end

    it 'cannot exceed 50 characters' do
      post.title = "Post " * 11
      expect(post).to_not be_valid
    end
  end

  describe '.description' do
    let(:post) { FactoryGirl.build(:post, title: 'Foo bar') }

    it 'is required' do
      post.description = nil
      post.save
      expect(post).to_not be_valid
    end

    it 'cannot exceed 500 characters' do
      post.description = "Post " * 101
      expect(post).to_not be_valid
    end
  end

  describe '.payment_type' do
    let(:post) { FactoryGirl.build(:post, title: 'Foo bar', description: 'Foo') }

    it 'is required' do
      post.payment_type = nil
      post.save
      expect(post).to_not be_valid
    end
  end

  describe '.pick_up_location' do
    let(:post) { FactoryGirl.build(:post, title: 'Foo bar', description: 'Foo') }

    it 'is required' do
      post.pick_up_location= nil
      post.save
      expect(post).to_not be_valid
    end
  end
end
