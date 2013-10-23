# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:uid)
    first_name 'Tester'
    sequence(:last_name) { |n| "#{n}" }
    name "Tester #{:last_name}"
    sequence(:facebook_email) { |n| "#{n}@facebook-test.local" }
    zipcode '75033'
  end
end
