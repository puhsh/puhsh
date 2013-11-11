require 'spec_helper'

describe User do

  it { should have_many(:posts) }
  it { should have_many(:followed_cities) }
  it { should have_many(:cities).through(:followed_cities) }
  it { should have_many(:offers) }
  it { should have_many(:flagged_posts) }
  it { should belong_to(:home_city) }
  it { should have_one(:access_token) }

  describe '.default_role' do
    let(:user) { FactoryGirl.build(:user) }

    it 'sets the user role to member' do
      user.save
      expect(user.reload.has_role?(:member)).to be_true
    end

    it 'does not change the role on update' do
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
    let(:user) { FactoryGirl.build(:user) }
    let(:city) { FactoryGirl.create(:city) }

    it 'sets the correct city on create' do
      user.zipcode = '75033'
      expect(user).to receive(:set_home_city)
      user.save
    end
  end

  describe '.add_app_invite' do
    let(:user) { FactoryGirl.build(:user) }

    it 'creates an app invite for a new user' do
      expect(user).to receive(:add_app_invite)
      user.save
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

  describe '.number_of_stars' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:star) { FactoryGirl.create(:star, user: user, amount: 10, reason: :alpha_registration) }

    it 'returns the count' do
      expect(user.reload.number_of_stars).to eql(20)
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
      it { should be_able_to(:manage, Item.new) }
      it { should be_able_to(:manage, Offer.new) }
      it { should be_able_to(:manage, FlaggedPost.new) }
      it { should be_able_to(:manage, FollowedCity.new) }
      it { should be_able_to(:manage, City.new) }
    end

    context 'member' do
      let(:user) { FactoryGirl.create(:user) } 

      it { should be_able_to(:manage, user) }
      it { should_not be_able_to(:manage, User.new) }
    end
  end
end
