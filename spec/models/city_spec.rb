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

  describe '.full_city_state' do
    let!(:city) { FactoryGirl.create(:city) }
    it 'sets the slug properly' do
      expect(city.reload.slug).to eql(city.full_city_state)
      expect(city.reload.slug).to eql("#{city.name.downcase}-#{city.full_state_name.downcase}")
    end
  end
end
