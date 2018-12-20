FactoryGirl.define do
  factory :invoice_product do
    association :invoice, factory: :invoice
    association :product, factory: :product
  end
end
