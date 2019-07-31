class InvoiceProduct < ApplicationRecord
  validates :product_price, :product_fee, :fee_rate, presence: true
  validates :fee_rate, inclusion: { in: (0..1).step(0.001) }

  belongs_to :user_product
  belongs_to :invoice

  scope :settled, -> { joins(:invoice).merge(Invoice.settled) }

  before_validation :fix_product_price_and_fee, on: :create

  def fix_product_price_and_fee
    return if user_product.nil? || invoice.nil?

    self.product_price = product_price_initial_calc
    self.product_fee = product_fee_to_pay
  end

  def discount_stock
    user_product.stock -= 1
    user_product.save!
  end

  def price_in_clp
    (product_price / invoice.satoshi_clp_ratio).round
  end

  def fee_percentage
    fee_rate * 100
  end

  private

  def product_price_initial_calc
    user_product.price * invoice.satoshi_clp_ratio
  end

  def product_fee_to_pay
    product_price * fee_rate
  end
end

# == Schema Information
#
# Table name: invoice_products
#
#  id              :bigint(8)        not null, primary key
#  invoice_id      :bigint(8)        not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  product_price   :integer          not null
#  user_product_id :bigint(8)
#  product_fee     :integer          default(0), not null
#  fee_rate        :decimal(, )      default(0.0), not null
#
# Indexes
#
#  index_invoice_products_on_invoice_id       (invoice_id)
#  index_invoice_products_on_user_product_id  (user_product_id)
#
