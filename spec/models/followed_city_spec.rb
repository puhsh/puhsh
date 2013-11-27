require 'spec_helper'

describe FollowedCity do
  it { should belong_to(:user) }
  it { should belong_to(:city) }

  describe '.create_multiple' do
    let(:user) { FactoryGirl.create(:user) }
    let!(:city) { FactoryGirl.create(:city) }
    let!(:city2) { FactoryGirl.create(:city) }

    it 'does not create any followed cities if a user is not provided' do
      FollowedCity.create_multiple([{city_id: city.id}], nil)
      expect(user.reload.followed_cities).to be_empty
    end

    it 'creates a followed city' do
      FollowedCity.create_multiple([{ city_id: city.id }], user)
      expect(user.reload.followed_cities.map(&:city)).to include(city)
    end

    it 'creates multiple followed cities' do
      FollowedCity.create_multiple([{ city_id: city.id }, { city_id: city2.id }], user)
      expect(user.reload.followed_cities.map(&:city)).to include(city)
      expect(user.reload.followed_cities.map(&:city)).to include(city2)
    end

     it 'does not return invalid records' do
       cities = FollowedCity.create_multiple([{ city_id: city.id }, { city_id: city.id }], user)
       expect(cities.map(&:city)).to include(city)
       expect(cities.size).to eql(1)
     end
  end
end
