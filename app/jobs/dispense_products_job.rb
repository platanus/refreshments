class DispenseProductsJob < ApplicationJob
  queue_as :default

  def perform(r_hash)
    invoice = Invoice.find_by!(r_hash: r_hash)
    invoice.invoice_products.settled.undispensed.each do |invoice_product|
      DispenseProduct.for(invoice_product: invoice_product)
    end
  end
end
