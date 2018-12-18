class InvoiceProduct < ApplicationRecord
  belongs_to :product
  belongs_to :invoice
end

# == Schema Information
#
# Table name: invoice_products
#
#  id         :bigint(8)        not null, primary key
#  product_id :bigint(8)        not null
#  invoice_id :bigint(8)        not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_invoice_products_on_invoice_id  (invoice_id)
#  index_invoice_products_on_product_id  (product_id)
#
