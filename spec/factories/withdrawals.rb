FactoryGirl.define do
  factory :withdrawal do
    amount 100
    btc_address '0x1234567890'
    association :user, factory: :user
  end
end
