class InvoiceObserver < PowerTypes::Observer
  after_save :register_invoice_products
  # after_save :broadcast_status_update

  def register_invoice_products
    puts "register invoice products in observer"
    object.invoice_products.each do |invoice_product|
      Ledger::RegisterInvoiceProductJob.set(wait: 5.seconds).perform_later(invoice_product)
    end
  end

  def broadcast_status_update
    puts "broadcast status update in observer"
    ActionCable.server.broadcast 'invoices', "InvoiceSerializer.new(object, root: false)"
  end
end
