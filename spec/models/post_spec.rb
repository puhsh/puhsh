require 'spec_helper'

describe Post do
  it { should belong_to(:user) }
  it { should have_one(:item) }
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

    it 'cannot exceed 1000 characters' do
      post.description = "Post " * 1000
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

  describe '.award_badges' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let!(:user2) { FactoryGirl.create(:user, home_city: city) }
    let!(:badge) { FactoryGirl.create(:badge, name: 'Newbie Poster') }
    let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let!(:new_post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }
    
    it 'awards the user a badge if it is their first post' do
      expect(user.reload.badges).to include(badge)
    end

    it 'does not award the user a badge if it is not their first post' do
      user2.posts_count = 10
      user2.save
      FactoryGirl.create(:post, user: user2, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory)
      expect(user2.reload.badges).to_not include(badge)
    end
  end

  describe '.store_category_name' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let!(:new_post) { FactoryGirl.build(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }

    it 'stores the category name in redis' do
      new_post.save
      expect(new_post.reload.category_name.value).to eql(category.name)
    end
  end

  describe '.store_subcategory_name' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let!(:new_post) { FactoryGirl.build(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }

    it 'stores the subcategory name in redis' do
      new_post.save
      expect(new_post.reload.subcategory_name.value).to eql(subcategory.name)
    end
  end

  describe '.offers' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let!(:new_post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }
    let!(:item) { FactoryGirl.create(:item, post: new_post, price_cents: 1000) }
    let!(:offer) { FactoryGirl.create(:offer, item: item) }

    it 'returns the offers based on the ids in the redis set' do
      expect(new_post.reload.offers).to include(offer)
    end
  end

  describe '.questions' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let!(:new_post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }
    let!(:item) { FactoryGirl.create(:item, post: new_post, price_cents: 1000) }
    let!(:question) { FactoryGirl.create(:question, item: item, content: 'Test question') }

    it 'returns the questions based on the ids in the redis set' do
      expect(new_post.reload.questions).to include(question)
    end
  end

  describe '.activity' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let!(:new_post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }
    let!(:item) { FactoryGirl.create(:item, post: new_post, price_cents: 1000) }
    let!(:offer) { FactoryGirl.create(:offer, item: item) }

    it 'returns the offers and questions for a post in descending order' do
      Timecop.travel(Date.today + 3.weeks) do
        question = FactoryGirl.create(:question, item: item, content: 'Test question')
        expect(new_post.reload.activity).to eql([offer, question])
      end
    end
  end

  describe '.for_users_or_cities' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let!(:user2) { FactoryGirl.create(:user, home_city: city) }
    let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let!(:new_post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }
    let!(:new_post2) { FactoryGirl.create(:post, user: user2, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }

    it 'returns posts for users or cities' do
      results = Post.for_users_or_cities(user2.id, city.id)
      expect(results).to include(new_post)
      expect(results).to include(new_post2)
    end
  end

  describe '.send_new_post_email' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let!(:new_post) { FactoryGirl.build(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }

    before { ResqueSpec.reset! }

    it 'sends an email to the user that created the post' do
      new_post.save
      expect(Puhsh::Jobs::EmailJob).to have_queued(:send_new_post_email, {post_id: new_post.id}).in(:email)
      expect_any_instance_of(Puhsh::Jobs::EmailJob).to receive(:send_new_post_email).with({'post_id' => new_post.id})
      ResqueSpec.perform_all(:email)
    end
  end

  describe '.flagged_by?' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:user2) { FactoryGirl.create(:user) }
    let!(:city) { FactoryGirl.create(:city) }
    let!(:zipcode) { FactoryGirl.create(:zipcode, city: city, code: '75033') }
    let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let!(:post) { FactoryGirl.build(:post, user: user2, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }
    let!(:flagged_post) { FactoryGirl.build(:flagged_post, user: user, post: post) }

    it 'returns false if the user did not flag the post' do
      expect(post).to_not be_flagged_by(user)
    end

    it 'returns true if the user flagged the post' do
      flagged_post.save
      expect(post.reload).to be_flagged_by(user.reload)
    end
  end
end
