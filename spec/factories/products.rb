FactoryBot.define do
  factory :product do
    name { 'custom product name' }
    user { create(:user) }
    stock { 10 }
    price { 1000 }
    image do
      fixture_file_upload(
        Rails.root.join('spec', 'support', 'assets', 'beverage.jpeg'), '
        image/jpg'
      )
    end
    category { :drinks }
  end
end
