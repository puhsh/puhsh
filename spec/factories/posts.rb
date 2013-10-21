# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    payment_type :both
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
