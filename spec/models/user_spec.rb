require 'spec_helper'

describe User do

  it { should have_many(:posts) }
  it { should have_many(:user_cities) }
  it { should have_many(:cities).through(:user_cities) }
  it { should have_many(:offers) }
  it { should have_many(:flagged_posts) }

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

    it 'is required' do
      user.facebook_email = nil
      user.save
      expect(user).to_not be_valid
    end
  end

  describe '.zipcode' do
    let(:user) { FactoryGirl.build(:user) }
    let(:existing_user) { FactoryGirl.create(:user) }

    it 'is not required on create' do
      expect(existing_user).to be_valid
    end

    it 'is required on update' do
      user.save
      user.zipcode = nil
      user.save
      expect(user).to_not be_valid
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
        expect(user.reload.first_name).to eq(@facebook_valid[:info][:first_name])
      end

      it 'saves the last name' do
        user = User.find_for_facebook_oauth(@facebook_valid)
        expect(user.reload.last_name).to eq(@facebook_valid[:info][:last_name])
      end

      it 'saves the full name' do
        user = User.find_for_facebook_oauth(@facebook_valid)
        expect(user.reload.name).to eq(@facebook_valid[:info][:name])
      end

      it 'saves the avatar url' do
        user = User.find_for_facebook_oauth(@facebook_valid)
        expect(user.reload.avatar_url).to eq(@facebook_valid[:info][:image])
      end

      it 'saves the facebook email' do
        user = User.find_for_facebook_oauth(@facebook_valid)
        expect(user.reload.facebook_email).to eq(@facebook_valid[:info][:email])
      end

      it 'saves the gender' do
        user = User.find_for_facebook_oauth(@facebook_valid)
        expect(user.reload.gender).to eq(@facebook_valid[:extra][:raw_info][:gender])
      end
    end

    context 'invalid user' do
      it 'does not create a record for non verified users' do
        user = User.find_for_facebook_oauth(@facebook_invalid)
        expect(user).to be_nil
      end
    end

    context 'existing user' do
      let(:user) { FactoryGirl.create(:user, uid: '1234', avatar_url: 'http://test.local/image.png') }

      it 'does not create a record for an existing user' do
        user = User.find_for_facebook_oauth(@facebook_valid)
        expect(user).to eql(user)
        expect(User.count).to eq(1)
      end

      it 'updates the avatar to the latest one if existing one differs from facebook' do
        user = User.find_for_facebook_oauth(@facebook_valid)
        expect(user.reload.avatar_url).to eq(@facebook_valid[:info][:image])
      end
    end
  end

  describe '.generate_access_token!' do
    let(:user) { FactoryGirl.create(:user) }

    it 'generates an access token for the user' do
      user.generate_access_token!
      expect(user.reload.authentication_token).to_not be_nil
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
      it { should be_able_to(:manage, UserCity.new) }
      it { should be_able_to(:manage, City.new) }
    end

    context 'member' do
      let(:user) { FactoryGirl.create(:user) } 

      it { should be_able_to(:manage, user) }
      it { should_not be_able_to(:manage, User.new) }
    end
  end
end
