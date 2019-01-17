FactoryBot.define do
  factory :product do
    sequence :name do |n|
      "Product Name #{n}"
    end

    image do
      fixture_file_upload(
        Rails.root.join('spec', 'support', 'assets', 'beverage.jpeg'), '
        image/jpg'
      )
    end
  end
end
