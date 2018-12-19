FactoryGirl.define do
  factory :product do
    price 1_000
    name "Coca Cola"
    image do
      fixture_file_upload(
        Rails.root.join('spec', 'support', 'assets', 'beverage.jpeg'), '
        image/jpg'
      )
    end
    active true
    association :user, factory: :user
  end
end
