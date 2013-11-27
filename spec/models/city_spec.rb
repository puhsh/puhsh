require 'spec_helper'

describe City do
  it { should have_many(:users) }
  it { should have_many(:followed_cities) }
  it { should have_many(:users).through(:followed_cities) }
  it { should have_many(:posts) }
  it { should have_many(:zipcodes) }

  describe '.follow!' do
    let(:user) { FactoryGirl.create(:user) }
    let(:city) { FactoryGirl.create(:city) }

    it 'follows a city for the user' do
      city.follow!(user)
      expect(user.reload.followed_cities.map(&:city)).to include(city)
    end
  end
end
