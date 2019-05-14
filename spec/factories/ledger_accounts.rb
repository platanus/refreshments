FactoryBot.define do
  factory :ledger_account do
    association :accountable, factory: :wallet
    category { "WALLET" }
    balance { 1 }
  end
end
