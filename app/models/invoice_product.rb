class InvoiceProduct < ApplicationRecord
  validates :product_price, presence: true

  belongs_to :product
  belongs_to :invoice

  scope :settled, -> { joins(:invoice).merge(Invoice.settled) }

  before_validation { fix_product_price }

  def fix_product_price
    fetch_product
    fetch_invoice
    return if @product.nil? || @invoice.nil?
    self.product_price = product_price_initial_calc
  end

  def fetch_product
    return unless product_id
    @product = Product.find(product_id)
  end

  def fetch_invoice
    return unless invoice_id
    @invoice = Invoice.find(invoice_id)
  end

  def product_price_initial_calc
    @product.price * @invoice.satoshi_clp_ratio
  end
end

# == Schema Information
#
# Table name: invoice_products
#
#  id            :bigint(8)        not null, primary key
#  product_id    :bigint(8)        not null
#  invoice_id    :bigint(8)        not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  product_price :integer          not null
#
# Indexes
#
#  index_invoice_products_on_invoice_id  (invoice_id)
#  index_invoice_products_on_product_id  (product_id)
#
