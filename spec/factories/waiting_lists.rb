# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :waiting_list do
    device_id SecureRandom.hex
    status :inactive
  end
end
