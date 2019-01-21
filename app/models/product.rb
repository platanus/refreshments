class Product < ApplicationRecord
  validates :name, presence: true
  validates :image, attached: true

  has_one_attached :image

  has_many :user_products
  has_many :users, through: :user_products
  has_many :invoice_products, through: :user_products
  has_many :invoices, through: :invoice_products

  scope :with_price, -> {
    joins(:user_products)
      .merge(UserProduct.for_sale)
      .group('products.id')
      .select(
        'products.*',
        'MIN(user_products.price) AS price'
      )
  }
end

# == Schema Information
#
# Table name: products
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
