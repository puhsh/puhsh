# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :city do
    zipcode '75002'
    state 'TX'
    city 'Allen'
  end
end
