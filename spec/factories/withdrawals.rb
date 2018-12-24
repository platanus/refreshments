FactoryGirl.define do
  factory :withdrawal do
    amount 100
    association :user, factory: :user
  end
end
