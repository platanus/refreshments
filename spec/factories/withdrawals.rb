FactoryGirl.define do
  factory :withdrawal do
    amount 100
    btc_address '1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i'
    association :user, factory: :user
  end
end
