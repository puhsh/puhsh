# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    sequence(:title) { |n| "Test Post #{n}" }
    sequence(:description) { |n| "Description #{n}" }
    pick_up_location :porch
    payment_type :both
    category { FactoryGirl.create(:category) }
    user { FactoryGirl.create(:user) }
  end

  factory :post_insta_payment do
    payment_type :insta_payment
  end

  factory :post_cash do
    payment_type :cash
  end

  factory :post_free do
    payment_type :free
  end
end
