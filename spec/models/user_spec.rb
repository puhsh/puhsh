require 'spec_helper'

describe User do

  it { should have_many(:posts) }
  it { should have_many(:user_cities) }
  it { should have_many(:cities).through(:user_cities) }
  it { should have_many(:offers) }
  it { should have_many(:flagged_posts) }

  context '.default_role' do
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

  describe '.find_for_facebook_oauth' do
  end
end
