class RegisterInvoicePaymentJob < ApplicationJob
  queue_as :ledger_transaction

  def perform(invoice_id)
    invoice = Invoice.find(invoice_id)
    RegisterInvoicePayment.for(invoice: invoice)
  end
end
