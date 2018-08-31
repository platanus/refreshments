class Product < ApplicationRecord
  validates :name, :price, presence: true

  has_one_attached :image
end

# == Schema Information
#
# Table name: products
#
#  id         :bigint(8)        not null, primary key
#  price      :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
