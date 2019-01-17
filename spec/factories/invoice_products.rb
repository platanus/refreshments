FactoryBot.define do
  factory :invoice_product do
    transient do
      invoice_settled { true }
    end

    invoice { create(:invoice, settled: invoice_settled) }
    user_product { create(:user_product) }
  end
end
