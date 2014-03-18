# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :city do
    state 'TX'
    name 'Frisco'
    full_state_name 'Texas'
  end

  factory :nyc do
    state 'NY'
    name 'New York City'
  end
end
