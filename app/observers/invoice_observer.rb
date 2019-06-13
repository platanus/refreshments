class InvoiceObserver < PowerTypes::Observer
  after_save :register_invoice_payment

  def register_invoice_payment
    RegisterInvoicePaymentJob.perform_later(object)
  end
end
