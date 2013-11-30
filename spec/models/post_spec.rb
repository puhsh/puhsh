require 'spec_helper'

describe Post do
  it { should belong_to(:user) }
  it { should have_many(:items) }
  it { should belong_to(:city) }
  it { should have_many(:flagged_posts) }
  it { should belong_to(:category) }
  it { should belong_to(:subcategory) }
  it { should have_many(:post_images) }

  let(:user) { FactoryGirl.create(:user) }
  let(:category) { FactoryGirl.create(:category) }

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

  describe '.category' do
    let(:post) { FactoryGirl.create(:post, title: 'Foo bar', description: 'Foo') }

    it 'defaults to the first and only category' do
      expect(post.category).to eq(Category.first)
    end

    it 'is required' do
      post.category = nil
      post.save
      expect(post).to_not be_valid
    end
  end

  describe '.subcategory' do
    let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let(:post) { FactoryGirl.build(:post, title: 'Foo bar', description: 'Foo') }

    it 'can be assigned to any subcategory' do
      post.subcategory = subcategory
      post.save
      expect(post.reload.subcategory).to eql(subcategory)
    end
  end

  describe '.city' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let(:new_post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }

    it 'defaults to the posting user\'s home city' do
      expect(new_post.reload.city).to eql(user.home_city)
    end
  end

  describe '.reward_stars' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let!(:new_post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }

    it 'grants a user 1 star after creating a post' do
      expect(user.reload.star_count).to eql(11)
    end
  end
end
