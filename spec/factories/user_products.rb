FactoryBot.define do
  factory :user_product do
    name { 'custom product name' }
    product { create(:product, name: product_name) }
    user { create(:user) }
    stock { 10 }
    price { 1000 }
    image do
      fixture_file_upload(
        Rails.root.join('spec', 'support', 'assets', 'beverage.jpeg'), '
        image/jpg'
      )
    end
  end
end
