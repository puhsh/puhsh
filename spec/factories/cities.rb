# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :city do
    zipcode '75033'
    state 'TX'
    city 'Frisco'
  end
end
