FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "test#{n}@email.com"
    end

    sequence :name do |n|
      "Test User #{n}"
    end

    password { '123456' }

    factory :user_with_product do
      transient do
        product_count { 1 }
      end

      after(:create) do |user, evaluator|
        create_list(:user_product, evaluator.product_count, user: user)
      end

      factory :user_with_invoice do
        transient do
          invoice_settled { true }
        end

        after(:create) do |user, evaluator|
          user.user_products.each do |user_product|
            create(:invoice_product, user_product: user_product, invoice_settled: evaluator.invoice_settled)
          end
        end
      end
    end
  end
end
