# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name 'Tester'
    sequence(:last_name) { |n| "#{n}" }
    name "Tester #{:last_name}"
  end
end
