FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "test#{n}@email.com"
    end

    sequence :name do |n|
      "Test User #{n}"
    end

    password { '123456' }

    trait :with_account do
      after(:create) do |user|
        create(:ledger_account, :with_line, accountable: user)
      end
    end

    trait :with_collected_fee do
      after(:create) do |user|
        create(:user_ledger_account, :with_fee_line, accountable: user)
      end
    end

    factory :user_with_product do
      transient do
        product_count { 1 }
      end

      after(:create) do |user, evaluator|
        create_list(:product, evaluator.product_count, user: user)
      end

      factory :user_with_invoice do
        transient do
          invoice_settled { true }
        end

        after(:create) do |user, evaluator|
          user.products.each do |product|
            create(:invoice_product,
              product: product,
              invoice_settled: evaluator.invoice_settled)
          end
        end
      end
    end
  end
end
