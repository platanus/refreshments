class InvoiceObserver < PowerTypes::Observer
  after_save :register_invoice_products

  def register_invoice_products
    object.invoice_products.each do |invoice_product|
      Ledger::RegisterInvoiceProductJob.set(wait: 5.seconds).perform_later(invoice_product)
    end
  end
end
