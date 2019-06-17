class RegisterInvoicePaymentJob < ApplicationJob
  queue_as :ledger_transaction

  def perform(invoice)
    RegisterInvoicePayment.for(invoice: invoice)
  end
end
