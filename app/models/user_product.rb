class UserProduct < ApplicationRecord
  validates :price, :stock, presence: true
  validates :price, :stock, numericality: { greater_than: 0 }

  scope :actives, -> { where(active: true) }

  belongs_to :user
  belongs_to :product
  has_many :invoice_products
  has_many :invoices, through: :invoice_products

  attr_readonly :product_id
end

# == Schema Information
#
# Table name: user_products
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)        not null
#  product_id :bigint(8)        not null
#  price      :integer          not null
#  stock      :integer          not null
#  active     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_products_on_product_id  (product_id)
#  index_user_products_on_user_id     (user_id)
#
