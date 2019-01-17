class Product < ApplicationRecord
  validates :name, presence: true
  validates :image, attached: true

  has_one_attached :image

  has_many :user_products
  has_many :users, through: :user_products
  has_many :invoice_products, through: :user_products
  has_many :invoices, through: :invoice_products

  def self.products_with_price
    all
      .joins(:user_products)
      .where('user_products.stock > 0')
      .where('user_products.active = true')
      .group('products.id')
      .select(
        'products.*',
        'MIN(user_products.price) AS price'
      )
  end
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
