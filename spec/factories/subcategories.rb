# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subcategory do
    category { FactoryGirl.create(:category) }
    name 'Baby Clothes'
  end
end
