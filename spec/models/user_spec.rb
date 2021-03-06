require 'spec_helper'
require 'vcr_helper'

describe User do

  it { should have_many(:posts) }
  it { should have_many(:followed_cities) }
  it { should have_many(:cities).through(:followed_cities) }
  it { should have_many(:offers) }
  it { should have_many(:flagged_posts) }
  it { should belong_to(:home_city) }
  it { should have_one(:access_token) }
  it { should have_one(:app_invite) }
  it { should have_many(:devices) }
  it { should have_many(:stars) }
  it { should have_many(:user_badges) }
  it { should have_many(:badges).through(:user_badges) }
  it { should have_many(:invites) }
  it { should have_many(:questions) }
  it { should have_many(:wall_posts) }
  it { should have_many(:follows) }
  it { should have_many(:followers) }
  it { should have_many(:sent_messages) }
  it { should have_many(:received_messages) }
  it { should have_many(:notifications) }
  it { should have_many(:sold_items) }
  it { should have_many(:bought_items) }

  describe '.default_role' do
    let!(:user) { FactoryGirl.build(:user) }

    it 'sets the user role to member' do
      user.save
      expect(user.reload.has_role?(:member)).to be_true
    end

    it 'does not change the role on update' do
      user = FactoryGirl.create(:user)
      user.add_role(:admin)
      user.save
      user.reload.touch
      expect(user.reload.has_role?(:admin)).to be_true
    end

    it 'never sets the user role to admin' do
      user.save
      expect(user.reload.has_role?(:admin)).to be_false
    end
  end

  describe '.uid' do
    let(:user) { FactoryGirl.build(:user) }

    it 'is required' do
      user.uid = nil
      user.save
      expect(user).to_not be_valid
    end
  end

  describe '.first_name' do
    let(:user) { FactoryGirl.build(:user) }

    it 'is required' do
      user.first_name = nil
      user.save
      expect(user).to_not be_valid
    end
  end

  describe '.last_name' do
    let(:user) { FactoryGirl.build(:user) }

    it 'is required' do
      user.last_name = nil
      user.save
      expect(user).to_not be_valid
    end
  end

  describe '.name' do
    let(:user) { FactoryGirl.build(:user) }

    it 'is required' do
      user.name = nil
      user.save
      expect(user).to_not be_valid
    end
  end

  describe '.facebook_email' do
    let(:user) { FactoryGirl.build(:user) }

    it 'is not required' do
      user.facebook_email = nil
      user.save
      expect(user).to be_valid
    end
  end

  describe '.zipcode' do
    let(:user) { FactoryGirl.build(:user) }
    let(:existing_user) { FactoryGirl.create(:user) }

    it 'is not required' do
      expect(existing_user).to be_valid
    end
  end

  describe '.find_for_facebook_oauth' do
    before { @facebook_invalid = OmniAuth.config.mock_auth[:facebook_invalid] }
    before { @facebook_valid = OmniAuth.config.mock_auth[:facebook] }
    before { @facebook_valid2 = OmniAuth.config.mock_auth[:facebook2] }

    context 'new valid user' do
      it 'creates records for verified users' do
        user = User.find_for_facebook_oauth(@facebook_valid)
        expect(user).to_not be_nil
      end

      it 'saves the uid' do
        user = User.find_for_facebook_oauth(@facebook_valid)
        expect(user.reload.uid).to eq(@facebook_valid[:uid])
      end

      it 'saves the first name' do
        user = User.find_for_facebook_oauth(@facebook_valid)
        expect(user.reload.first_name).to eq(@facebook_valid[:first_name])
      end

      it 'saves the last name' do
        user = User.find_for_facebook_oauth(@facebook_valid)
        expect(user.reload.last_name).to eq(@facebook_valid[:last_name])
      end

      it 'saves the full name' do
        user = User.find_for_facebook_oauth(@facebook_valid)
        expect(user.reload.name).to eq(@facebook_valid[:name])
      end

      it 'saves the avatar url' do
        user = User.find_for_facebook_oauth(@facebook_valid)
        expect(user.reload.avatar_url).to eq("http://graph.facebook.com/#{@facebook_valid[:id]}/picture?type=square")
      end

      it 'saves the facebook email' do
        user = User.find_for_facebook_oauth(@facebook_valid)
        expect(user.reload.facebook_email).to eq(@facebook_valid[:email])
      end

      it 'saves the gender' do
        user = User.find_for_facebook_oauth(@facebook_valid)
        expect(user.reload.gender).to eq(@facebook_valid[:gender])
      end

      it 'handles duplicates' do
        user = User.find_for_facebook_oauth(@facebook_valid)
        user2 = User.find_for_facebook_oauth(@facebook_valid2)
        expect(user.reload).to be_valid
        expect(user2.reload).to be_valid
        expect(user.reload.slug).to_not eql(user2.reload.slug)
      end
    end

    context 'existing user' do
      let(:user) { FactoryGirl.create(:user, uid: '1234', avatar_url: 'http://test.local/image.png') }

      it 'does not create a record for an existing user' do
        user = User.find_for_facebook_oauth(@facebook_valid)
        expect(User).to_not receive(:create)
        expect(user.reload).to eql(user)
      end

      it 'updates the avatar to the latest one if existing one differs from facebook' do
        user = User.find_for_facebook_oauth(@facebook_valid)
        expect(user.reload.avatar_url).to eq("http://graph.facebook.com/#{@facebook_valid[:id]}/picture?type=square")
      end
    end
  end

  describe '.generate_access_token!' do
    let(:user) { FactoryGirl.create(:user) }
    let(:existing_user) { FactoryGirl.create(:user) }
    let(:existing_user2) { FactoryGirl.create(:user) }
    let!(:expired_access_token) { FactoryGirl.create(:access_token, user: existing_user, expires_at: 2.weeks.ago) }
    let!(:valid_access_token) { FactoryGirl.create(:access_token, user: existing_user2) }


    it 'generates an access token for a new user' do
      user.generate_access_token!
      expect(user.reload.access_token).to_not be_nil
    end

    it 'refreshes an access token for an existing user if the token is expired' do
      existing_user.generate_access_token!
      expect(existing_user.reload.access_token).to eq(expired_access_token.reload)
    end

    it 'does not refresh an access token for an existing user if the token is valid' do
      existing_user2.generate_access_token!
      expect(existing_user2.reload.access_token).to eql(valid_access_token)
    end
  end

  describe '.set_home_city' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:city2) { FactoryGirl.create(:city, name: 'New York City', state: 'NY') }
    let!(:zipcode) { FactoryGirl.create(:zipcode, city_id: city.id) }
    let!(:zipcode_nyc) { FactoryGirl.create(:nyc_zip, city_id: city2.id) }

    it 'follows the city when the zipcode changes and the home city changed' do
      user = FactoryGirl.create(:user, zipcode: nil)
      user.zipcode = '75034'
      user.home_city = city
      user.save
      expect(user.reload.followed_cities.map(&:city)).to include(city)

      user.zipcode = '10021'
      user.home_city = city2
      user.save
      expect(user.reload.followed_cities.map(&:city)).to include(city2)
    end

    it 'follows the city when the zipcode and home city were blank' do
      user = FactoryGirl.create(:user, zipcode: nil)
      user.save
      expect(user.reload.followed_cities.map(&:city)).to_not include(city)

      user.zipcode = '75034'
      user.home_city = city
      user.save
      expect(user.reload.followed_cities.map(&:city)).to include(city)
    end

    it 'does not follow the city when the zipcode changes and the home city remained the same' do
      user = FactoryGirl.create(:user, zipcode: nil)
      user.zipcode = '75034'
      user.home_city = city
      user.save
      expect(user.reload.followed_cities.map(&:city)).to include(city)

      user.zipcode = '10021'
      user.save
      expect(user.reload.followed_cities.map(&:city)).to include(city)
      expect(user.reload.followed_cities.map(&:city)).to_not include(city2)
    end

    it 'follows the city when the zipcode was present and then the home city was added later' do
      user = FactoryGirl.create(:user, zipcode: nil)
      user.zipcode = '75034'
      user.save
      expect(user.reload.followed_cities.map(&:city)).to_not include(city)
      user.home_city = city
      user.save
      expect(user.reload.followed_cities.map(&:city)).to include(city)
    end
  end

  describe '.reward_stars' do
    let(:user) { FactoryGirl.build(:user) }

    it 'grants a user 10 stars after creating an account' do
      expect(user).to receive(:reward_stars)
      user.save
      expect(user.reload.stars).to_not be_nil
    end
  end

  describe '.nearby_cities' do
    let(:user) { FactoryGirl.create(:user, zipcode: '75034') }
    let!(:city) { FactoryGirl.create(:city) }
    let!(:new_york) { FactoryGirl.create(:city, name: 'New York City', state: 'NY') }
    let!(:zipcode) { FactoryGirl.create(:zipcode, city_id: city.id) }
    let!(:ny_zipcode) { FactoryGirl.create(:nyc_zipcode, city_id: new_york.id) }

    it 'returns nearby cities' do
      expect(user.reload.nearby_cities).to include(city)
    end

    it 'does not return cities far away' do
      expect(user.nearby_cities).to_not include(new_york)
    end

    it 'does not return duplicates' do
     duplicate = FactoryGirl.create(:zipcode, city_id: city.id)
     expect(user.nearby_cities.size).to eql(1)
     expect(user.reload.nearby_cities).to include(city)
     expect(user.reload.nearby_cities).to_not include(duplicate)
    end

    it 'can use a farther radius' do
      expect(user.nearby_cities(10000)).to include(new_york)
    end
  end

  describe '.following?' do
    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:user3) { FactoryGirl.create(:user) }

    it 'returns true if the user is following the user' do
      Follow.create(user: user, followed_user: user2)
      expect(user.reload.following?(user2)).to be_true
    end

    it 'returns false if the user is not following the user' do
      expect(user.reload.following?(user3)).to be_false
    end
  end

  describe '.followed_by?' do
    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:user3) { FactoryGirl.create(:user) }

    it 'returns true if the user is following the user' do
      Follow.create(user: user2, followed_user: user)
      expect(user.reload.followed_by?(user2)).to be_true
    end

    it 'returns false if the user is not following the user' do
      expect(user.reload.followed_by?(user3)).to be_false
    end
  end

  describe '.users_following' do
    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:user3) { FactoryGirl.create(:user) }

    it 'returns the users the user is following' do
      Follow.create(user: user, followed_user: user2)
      Follow.create(user: user, followed_user: user3)
      expect(user.users_following).to include(user2)
      expect(user.users_following).to include(user3)
    end
  end

  describe '.users_followers' do
    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:user3) { FactoryGirl.create(:user) }

    it 'returns the users the user is following' do
      Follow.create(user: user2, followed_user: user)
      Follow.create(user: user3, followed_user: user)
      expect(user.users_followers).to include(user2)
      expect(user.users_followers).to include(user3)
    end
  end

  describe '.friends?' do
    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:user3) { FactoryGirl.create(:user) }

    it 'returns true if the user is following and followed by the user' do
      Follow.create(user: user, followed_user: user2)
      Follow.create(user: user2, followed_user: user)
      expect(user.reload.friends?(user2)).to be_true
      expect(user2.reload.friends?(user)).to be_true
    end

    it 'returns false if the user is following but not followed by the user' do
      Follow.create(user: user, followed_user: user3)
      expect(user.reload.friends?(user3)).to be_false
      expect(user3.reload.friends?(user)).to be_false
    end

    it 'returns false if the user is not following but followed by the user' do
      Follow.create(user: user2, followed_user: user)
      expect(user.reload.friends?(user2)).to be_false
      expect(user2.reload.friends?(user)).to be_false
    end
  end

  describe '.recently_registered?' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:user_existing) { FactoryGirl.create(:user, contact_email: 'test@test.local') }

    it 'is true when the user adds the contact email' do
      user.contact_email = 'test@test2.local'
      expect(user.recently_registered?).to be_true
    end

    it 'is false when the user updates their contact email' do
      user_existing.contact_email = 'updated@test.local'
      expect(user_existing.recently_registered?).to be_false
    end

    it 'is false when ther user has no contact email' do
      expect(user.recently_registered?).to be_false
    end
  end

  describe '.send_welcome_email' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:new_user) { FactoryGirl.build(:user) }
    let!(:user_existing) { FactoryGirl.create(:user, contact_email: 'test@test.local') }
    before { ResqueSpec.reset! }

    it 'sends the welcome email' do
      user.contact_email = 'new.user@test.local'
      user.save
      expect(Puhsh::Jobs::EmailJob).to have_queued(:send_welcome_email, {user_id: user.id}).in(:email)
    end

    it 'does not send a welcome email to a brand new user' do
      new_user.save
      expect(Puhsh::Jobs::EmailJob).to_not have_queued(:send_welcome_email, {user_id: new_user.id}).in(:email)
      expect_any_instance_of(Puhsh::Jobs::EmailJob).to_not receive(:send_welcome_email).with({'user_id' => new_user.id})
      ResqueSpec.perform_all(:email)
    end

    it 'does not send a welcoem email to an existing user that updates their contact email' do
      user_existing.contact_email = 'updated@test.local'
      user_existing.save
      expect(Puhsh::Jobs::EmailJob).to_not have_queued(:send_welcome_email, {user_id: user_existing.id}).in(:email)
      expect_any_instance_of(Puhsh::Jobs::EmailJob).to_not receive(:send_welcome_email).with({'user_id' => user_existing.id})
      ResqueSpec.perform_all(:email)
    end
  end

  describe '.send_facebook_friend_joined_email' do
    subject(:test_users) { Koala::Facebook::TestUsers.new(app_id: FACEBOOK_APP_ID, secret: FACEBOOK_APP_SECRET) }
    let!(:new_user) { FactoryGirl.build(:user) }
    before { ResqueSpec.reset! }

    it 'sends an email to the user\'s facebook friends when they join' do
      VCR.use_cassette('/models/user/send_facebook_friend_joined_email') do
        user = test_users.create(true)
        FacebookTestUser.create(fbid: user['id'])
        new_user.uid = user['id']
        new_user.contact_email = 'test@test.local'
        new_user.save
        expect(Puhsh::Jobs::EmailJob).to have_queued(:send_facebook_friend_joined_email, {user_id: new_user.reload.id}).in(:email)
      end
    end
  end

  describe '.contactable?' do
    let!(:new_user) { FactoryGirl.build(:user) }

    it 'is false if there is no contact email' do
      new_user.save
      expect(new_user.reload).to_not be_contactable
    end

    it 'is true if there is a contact email' do
      new_user.contact_email = 'test@test.local'
      new_user.save
      expect(new_user.reload).to be_contactable
    end
  end

  describe '.other_avatar_urls' do
    let(:user) { FactoryGirl.create(:user, avatar_url: 'http://graph.facebook.com/1/picture?type=square') }

    it 'returns other sizes for the user\'s facebook avatar' do
      expect(user.other_avatar_urls).to eql({small: '//graph.facebook.com/1/picture?type=small&width=100&height=100', normal: '//graph.facebook.com/1/picture?type=normal&width=100&height=100', large: '//graph.facebook.com/1/picture?type=large&width=100&height=100'})
    end

    it 'returns an empty hash if there is no avatar url' do
      user.avatar_url = nil
      user.save
      expect(user.reload.other_avatar_urls).to eql({})
    end
  end

  describe '.reset_unread_notifications_count!' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:actor) { FactoryGirl.create(:user) }
    let!(:message) { FactoryGirl.create(:message, sender: actor, recipient: user, content: 'Hello') }
    let!(:message2) { FactoryGirl.create(:message, sender: actor, recipient: user, content: 'Hello') }
    let!(:message3) { FactoryGirl.create(:message, sender: user, recipient: actor, content: 'Hello') }
    let!(:notification) { FactoryGirl.create(:notification, user: user, actor: actor, content: message) }
    let!(:notification2) { FactoryGirl.create(:notification, user: user, actor: actor, content: message2) }
    let!(:notification3) { FactoryGirl.create(:notification, user: actor, actor: user, content: message3) }

    it 'resets the notification count to the amount unread' do
      expect(user.reload.unread_notifications_count).to eql(2)
      notification.mark_as_read!
      notification2.mark_as_read!
      user.reset_unread_notifications_count!
      expect(user.reload.unread_notifications_count).to eql(0)
    end
  end

  describe '.change_unsold_posts_city!' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let!(:post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory, status: :for_sale) }
    let!(:city2) { FactoryGirl.create(:city, name: 'New York City', state: 'NY') }
    let!(:zipcode_nyc) { FactoryGirl.create(:nyc_zip, city_id: city2.id) }

    it 'updates the user\'s posts, that are for sale, city when they change their home city' do
      expect(post.reload.city).to eql(user.home_city)
      user.zipcode = zipcode_nyc.code
      user.home_city = city2
      user.save
      expect(post.reload.city).to eql(city2)
      expect(post.reload.city).to_not eql(city)
    end

    it 'updates the posts counts for the previous city and the new city' do
      expect(city.reload.posts_count).to eql(1)
      expect(city2.reload.posts_count).to eql(0)

      user.zipcode = zipcode_nyc.code
      user.home_city = city2
      user.save

      expect(city.reload.posts_count).to eql(0)
      expect(city2.reload.posts_count).to eql(1)
    end

  end

  describe 'abilities' do
    subject(:ability) { Ability.new(user) }
    let(:user) { nil }

    context 'admin' do
      let(:user) { FactoryGirl.create(:user) }
      before { user.add_role :admin }

      it { should be_able_to(:manage, User.new) }
      it { should be_able_to(:manage, Post.new) }
      it { should be_able_to(:manage, PostImage.new) }
      it { should be_able_to(:manage, Item.new) }
      it { should be_able_to(:manage, Offer.new) }
      it { should be_able_to(:manage, FlaggedPost.new) }
      it { should be_able_to(:manage, FollowedCity.new) }
      it { should be_able_to(:manage, City.new) }
    end

    context 'member' do
      let(:user) { FactoryGirl.create(:user) }
      let(:user2) { FactoryGirl.create(:user) }

      it { should be_able_to(:manage, user) }
      it { should_not be_able_to(:manage, User.new) }

      it { should be_able_to(:manage, Device.new(user: user)) }
      it { should_not be_able_to(:manage, Device.new(user: user2)) }

      it { should be_able_to(:manage, Invite.new(user: user)) }
      it { should_not be_able_to(:manage, Invite.new(user: user2)) }

      it { should be_able_to(:manage, AppInvite.new(user: user)) }
      it { should_not be_able_to(:manage, AppInvite.new(user: user2)) }

      it { should_not be_able_to(:manage, Category.new) }
      it { should_not be_able_to(:manage, Subcategory.new) }

      it { should be_able_to(:read, Category.new) }
      it { should be_able_to(:read, Subcategory.new) }

      it { should_not be_able_to(:manage, Star.new(user: user)) }
      it { should be_able_to(:read, Star.new(user: user)) }

      it { should_not be_able_to(:manage, UserBadge.new(user: user)) }
      it { should be_able_to(:read, UserBadge.new(user: user)) }

      it { should_not be_able_to(:manage, Badge.new) }
      it { should be_able_to(:read, Badge.new) }

      it { should be_able_to(:manage, FollowedCity.new(user: user)) }
      it { should_not be_able_to(:manage, FollowedCity.new(user: user2)) }

      it { should_not be_able_to(:manage, City.new) }
      it { should be_able_to(:read, City.new) }

      it { should be_able_to(:manage, Post.new(user: user)) }
      it { should_not be_able_to(:manage, Post.new(user: user2)) }
      it { should be_able_to(:read, Post.new(user: user2)) }

      it { should be_able_to(:manage, Item.new(post: Post.new(user: user))) }
      it { should_not be_able_to(:manage, Item.new(post: Post.new(user: user2))) }
      it { should be_able_to(:read, Item.new(post: Post.new(user: user2))) }

      it { should be_able_to(:manage, Offer.new(user: user)) }
      it { should be_able_to(:manage, Offer.new(user: user2, item: Item.new(post: Post.new(user: user)))) }
      it { should_not be_able_to(:manage, Offer.new(user: user2)) }
      it { should be_able_to(:read, Offer.new(user: user2)) }

      it { should be_able_to(:manage, Question.new(user: user)) }
      it { should_not be_able_to(:manage, Question.new(user: user2)) }
      it { should be_able_to(:read, Question.new(user: user2)) }

      it { should be_able_to(:manage, FlaggedPost.new(user: user)) }
      it { should_not be_able_to(:manage, FlaggedPost.new(user: user2)) }

      it { should be_able_to(:manage, WallPost.new(user: user)) }
      it { should_not be_able_to(:manage, WallPost.new(user: user2)) }

      it { should be_able_to(:manage, Follow.new(user: user)) }
      it { should_not be_able_to(:manage, Follow.new(user: user2)) }
      it { should be_able_to(:read, Follow.new(user: user2)) }

      it { should be_able_to(:manage, Message.new(sender: user)) }
      it { should_not be_able_to(:manage, Message.new(sender: user2)) }
      it { should be_able_to(:read, Message.new(recipient: user)) }

      it { should be_able_to(:manage, Notification.new(user: user)) }
      it { should be_able_to(:manage, Notification.new(actor: user)) }
      it { should_not be_able_to(:manage, Notification.new(user: user2)) }
      it { should be_able_to(:read, Notification.new(user: user2)) }

      it { should be_able_to(:read, RelatedProduct.new) }

      it { should_not be_able_to(:manage, FacebookTestUser.new) }
    end
  end
end
