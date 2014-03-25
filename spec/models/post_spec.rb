require 'spec_helper'

describe Post do
  it { should belong_to(:user) }
  it { should have_one(:item) }
  it { should belong_to(:city) }
  it { should have_many(:flagged_posts) }
  it { should belong_to(:category) }
  it { should belong_to(:subcategory) }
  it { should have_many(:post_images) }
  it { should have_many(:questions) }
  it { should have_many(:offers) }
  it { should have_one(:item_transaction) }
  it { should have_one(:star) }

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

    it 'grants a user 10 stars after creating a post' do
      expect(user.reload.star_count).to eql(20)
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
    let!(:offer) { FactoryGirl.create(:offer, item: item, post: new_post) }

    it 'returns the offers based on the ids in the redis set' do
      expect(new_post.reload.offers).to include(offer)
    end
  end

  describe '.activity' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let!(:new_post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }
    let!(:item) { FactoryGirl.create(:item, post: new_post, price_cents: 1000) }
    let!(:offer) { FactoryGirl.create(:offer, item: item, post: new_post) }

    it 'returns the offers and questions for a post in descending order' do
      Timecop.travel(Date.today + 3.weeks) do
        question = FactoryGirl.create(:question, item: item, content: 'Test question', post: new_post)
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

  context '.search' do
    it { should have_searchable_field(:title) }
    it { should have_searchable_field(:description) }
    it { should have_searchable_field(:category_id) }
    it { should have_searchable_field(:created_at) }

    it 'orders by created at desc' do
      Post.search('title')
      expect(Sunspot.session).to have_search_params(:order_by, :created_at, :desc)
    end

    it 'paginates' do
      Post.search('title', 1, 30)
      expect(Sunspot.session).to have_search_params(:paginate)
    end

    it 'searches without category_id' do
      Post.search('title', 1, 25, { without_category_ids: [1,2,3,]})
      expect(Sunspot.session).to have_search_params(:without, :category_id, [1,2,3])
    end

  end

  describe '.remove_post_id_from_redis' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let!(:user2) { FactoryGirl.create(:user, home_city: city) }
    let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let!(:new_post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }
    let!(:item) { FactoryGirl.create(:item, post: new_post, price_cents: 1000) }
    let!(:offer) { FactoryGirl.create(:offer, item: item, post: new_post, amount_cents: 999, user: user2) }
    let!(:question) { FactoryGirl.create(:question, item: item, user: user2, post: new_post, content: 'Test question') }

    it 'clears out the question ids associated to this post' do
      expect(new_post.question_ids).to_not be_empty
      new_post.destroy
      new_post.send(:remove_post_id_from_redis)
      expect(new_post.question_ids).to be_empty
    end

    it 'clears out the subcategory and category name' do
      new_post.destroy
      new_post.send(:remove_post_id_from_redis)
      expect(new_post.subcategory_name).to be_nil
      expect(new_post.category_name).to be_nil
    end
  end

  describe '.destroy' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let!(:new_post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }

    it 'removes the stars' do
      expect(user.reload.star_count).to eql(20)
      new_post.destroy
      expect(user.reload.star_count).to eql(10)
    end

    it 'creates a star record with negative stars and a deleted_post event' do
      new_post.destroy
      expect(user.reload.stars.collect(&:event)).to include(:deleted_post)
    end
  end

  describe '.sold!' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let!(:new_post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }
    let!(:new_post2) { FactoryGirl.build(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }

    it 'rewards the seller stars' do
      new_post.sold!
      expect(user.reload.stars.map(&:event)).to include(:sold_item)
      expect(user.reload.star_count).to eql(30)
    end

    it 'marks the item as sold' do
      new_post.sold!
      expect(new_post.reload).to be_sold
    end
  end

  describe '.store_users_who_have_posted_for_city' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let!(:new_post) { FactoryGirl.build(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }

    it 'stores the user id in a redis set for the city' do
      new_post.save
      expect(city.reload.user_ids_with_posts_in_city.members).to include(user.id.to_s)
    end
  end
end
