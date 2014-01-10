require 'spec_helper'

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

      it 'stores an iOS mobile device type if specified' do
        user = User.find_for_facebook_oauth(@facebook_valid, 'ios')
        expect(user.reload.mobile_device_type.value).to eql('ios')
      end

      it 'stores an Android mobile device type if specified' do
        user = User.find_for_facebook_oauth(@facebook_valid, 'android')
        expect(user.reload.mobile_device_type.value).to eql('android')
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
    let!(:zipcode) { FactoryGirl.create(:zipcode, city_id: city.id) }

    it 'sets the correct city on create' do
      user = FactoryGirl.create(:user)
      user.save
      expect(user.reload.home_city).to eql(city)
    end

    it 'sets the correct city on update' do
      user = FactoryGirl.create(:user, zipcode: nil)
      user.save
      expect(user.reload.home_city).to be_nil
      user.reload.zipcode = '75034'
      user.save
      expect(user.reload.home_city).to eql(city)
    end

    it 'follows the home city automatically' do
      user = FactoryGirl.create(:user)
      user.save
      expect(user.reload.followed_cities.map(&:city)).to include(city)
    end
  end

  describe '.add_app_invite!' do
    before { @facebook_valid = OmniAuth.config.mock_auth[:facebook] }

    it 'does not create an app invite for a new user if the device is not specified' do
      user = User.find_for_facebook_oauth(@facebook_valid)
      expect(user.reload.app_invite).to be_nil
      expect(user.android_app_invite).to be_nil
    end

    it 'creates an app invite for a new user if they have an iOS device' do
      user = User.find_for_facebook_oauth(@facebook_valid, 'ios')
      expect(user.reload.app_invite).to_not be_nil
      expect(user.android_app_invite).to be_nil
    end

    it 'creates an app invite for a new user if they have an android' do
      user = User.find_for_facebook_oauth(@facebook_valid, 'android')
      expect(user.reload.app_invite).to be_nil
      expect(user.android_app_invite).to_not be_nil
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

  describe '.award_badges' do
    let(:user) { FactoryGirl.build(:user) }
    let!(:badge) { FactoryGirl.create(:badge, name: 'Early Adopter') }
    
    context 'Early Adopter' do
      context 'disabled alpha' do
        before { User::ALPHA_ENABLED = false }
        it 'does not award the early adopter badge if the alpha is disabled' do
          expect(Badge).to_not receive(:award!)
          user.save
        end
      end
      
      context 'enabled alpha' do
        before { User::ALPHA_ENABLED = true }
        it 'does award the early adopter badge if the alpha is enabled' do
          expect(Badge).to receive(:award!)
          user.save
        end
      end
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

      it { should be_able_to(:manage, AndroidAppInvite.new(user: user)) }
      it { should_not be_able_to(:manage, AndroidAppInvite.new(user: user2)) }

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

      it { should be_able_to(:manage, WallPost.new(user: user)) }
      it { should_not be_able_to(:manage, WallPost.new(user: user2)) }
    end
  end
end
