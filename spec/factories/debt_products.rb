FactoryBot.define do
  factory :debt_product do
    sequence(:debtor) { |n| "debtor_#{n}" }
    product_price { 1 }
    product
  end
end
