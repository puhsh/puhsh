require 'spec_helper'

describe CitiesHelper do
  let!(:city) { FactoryGirl.create(:city) }
  let!(:user) { FactoryGirl.create(:user, home_city: city) }

  describe '.city_state_name' do
    it 'returns the city\'s name in the format City, State' do
      expect(city_state_name(city)).to eql "#{city.name}, #{city.full_state_name}"
    end
  end

  describe '.city_founded_date' do
    it 'returns the date in standard format' do
      expect(city_founded_date(city)).to eql user.followed_cities.first.created_at
    end

    it 'returns the date in a fancy format' do
      expect(city_founded_date(city, :fancy)).to eql user.followed_cities.first.created_at.strftime("%m.%d.%Y")
    end
  end
end
