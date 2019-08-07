FactoryBot.define do
  factory :ledger_account do
    association :accountable, factory: :wallet
    category { 'WALLET' }
    balance { 1 }

    trait :with_line do
      transient do
        invoice_product { create(:invoice_product) }
      end

      after(:create) do |account, evaluator|
        create(
          :ledger_line,
          ledger_account: account,
          accountable: evaluator.invoice_product,
          balance: -100000
        )
      end
    end

    factory :user_ledger_account do
      association :accountable, factory: :user
      category { 'available_funds' }
      balance { -1000 }
    end
  end
end
