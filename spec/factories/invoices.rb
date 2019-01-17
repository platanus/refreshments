FactoryBot.define do
  factory :invoice do
    amount { 100000 }
    clp { 1000 }
    payment_request { 'MyString' }
    r_hash { 'MyString' }
    memo { 'MyString' }
    settled { true }
  end
end
