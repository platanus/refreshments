FactoryGirl.define do
  factory :invoice do
    satoshis 1
    clp 1
    payment_request "MyString"
    r_hash "MyString"
    memo "MyString"
    settled true
  end
end
