class InvoiceObserver < PowerTypes::Observer
  after_save :register_invoice_payment

  def register_invoice_payment
    RegisterInvoicePaymentJob.set(wait: 2.seconds).perform_later(object.id)
  end
end
