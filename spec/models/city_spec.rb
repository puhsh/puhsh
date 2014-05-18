require 'spec_helper'

describe City do
  it { should have_many(:users) }
  it { should have_many(:followed_cities) }
  it { should have_many(:users).through(:followed_cities) }
  it { should have_many(:posts) }
  it { should have_many(:zipcodes) }
  it { should have_many(:home_users) }

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

  describe '.pioneer?' do
    let!(:city) { FactoryGirl.create(:city) }
    let!(:user) { FactoryGirl.create(:user, home_city: city) }
    let!(:user2) { FactoryGirl.create(:user, home_city: city) }
    let(:subcategory) { FactoryGirl.create(:subcategory, name: 'Test Subcategory') }
    let!(:post) { FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory) }

    it 'is true if the user is the only one with posts in the city' do
      expect(city.reload.pioneer?(user)).to be_true
      expect(city.reload.pioneer?(user2)).to be_false
    end

    it 'is true if the user keeps adding posts to the city but is still the only one posting' do
      FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory)
      FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory)
      FactoryGirl.create(:post, user: user, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory)
      expect(city.reload.pioneer?(user)).to be_true
      expect(city.reload.pioneer?(user2)).to be_false
    end

    it 'is false if the user is not the only one with posts in the city' do
      FactoryGirl.create(:post, user: user2, title: 'Test', description: 'Test post', pick_up_location: :porch, payment_type: :cash, subcategory: subcategory)
      expect(city.reload.pioneer?(user)).to be_false
      expect(city.reload.pioneer?(user2)).to be_false
    end
  end

  context 'scopes' do
    describe '.us_states' do
      let!(:city) { FactoryGirl.create(:city, state: 'TX', full_state_name: 'Texas') }
      let!(:city2) { FactoryGirl.create(:city, state: 'TX', full_state_name: 'Texas') }
      let!(:city3) { FactoryGirl.create(:city, state: 'CA', full_state_name: 'California') }

      it 'returns the US states based on all the cities' do
        expect(City.us_states.map(&:full_state_name)).to include('Texas')
        expect(City.us_states.map(&:full_state_name)).to include('California')
        expect(City.us_states.to_a.size).to eql(2)
      end
    end

  end
end
