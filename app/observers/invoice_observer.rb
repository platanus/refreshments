class InvoiceObserver < PowerTypes::Observer
  after_save :register_invoice_payment

  def register_invoice_payment
    RegisterInvoicePayment.for(invoice: object)
  end
end
