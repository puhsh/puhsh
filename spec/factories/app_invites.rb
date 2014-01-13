# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :app_invite do
    status :inactive
    device_type :ios
  end
end
