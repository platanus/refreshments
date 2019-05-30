FactoryBot.define do
  factory :ledger_line do
    association :ledger_account, factory: :ledger_account
    association :accountable, factory: :invoice
    amount { 1 }
    sequence(:balance) { |n| n }
    date { '2019-04-29' }
  end
end
