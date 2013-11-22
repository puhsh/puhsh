# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :zipcode do
    code '75034'
    city_name 'Frisco'
    state 'TX'
    latitude 33.1499
    longitude -96.8241
  end

  factory :nyc_zipcode, class: Zipcode do
    city_name 'New York City'
    state 'NY'
    latitude 40.7143528
    longitude -74.0059731
  end
end
