FactoryBot.define do
  factory :user_product do
    transient do
      product_name { 'custom product name' }
    end

    product { create(:product, name: product_name) }
    user { create(:user) }
    stock { 10 }
    price { 1000 }
  end
end
