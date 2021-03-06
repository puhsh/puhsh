require 'spec_helper'

describe FollowedCity do
  it { should belong_to(:user) }
  it { should belong_to(:city) }

  describe '.city_id' do
    let(:user) { FactoryGirl.create(:user) }
    let(:city) { FactoryGirl.create(:city) }
    let(:followed_city) { FactoryGirl.build(:followed_city, user: user) }
    
    it 'is required' do
      followed_city.save
      expect(followed_city).to_not be_valid
    end

    it 'must be unique per user' do
      followed_city.city = city
      followed_city.save
      followed_city2 = FactoryGirl.build(:followed_city, user: user, city: city)
      followed_city2.save
      expect(followed_city2).to_not be_valid
    end
  end

  describe '.user_id' do
    let(:city) { FactoryGirl.create(:city) }
    let(:followed_city) { FactoryGirl.build(:followed_city, city: city) }

    it 'is required' do
      followed_city.save
      expect(followed_city).to_not be_valid
    end
  end

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

  describe '.store_city_id_for_user' do
    let(:user) { FactoryGirl.create(:user) }
    let!(:city) { FactoryGirl.create(:city) }

    it 'stores the followed city\'s city id in redis' do
      fc = FollowedCity.create(user: user, city: city)
      fc.run_callbacks(:commit)
      expect(user.reload.followed_city_ids.members).to include(city.id.to_s)
    end
  end

  describe '.remove_city_id_from_user' do
    let(:user) { FactoryGirl.create(:user) }
    let!(:city) { FactoryGirl.create(:city) }
   
    it 'removes the record from the redis set after it is deleted' do
      fc = FollowedCity.create(user: user, city: city)
      fc.run_callbacks(:commit)
      expect(user.reload.followed_city_ids.members).to include(city.id.to_s)
      fc.destroy
      fc.run_callbacks(:destroy)
      expect(user.followed_city_ids.members).to_not include(city.id.to_s)
    end
  end
end
