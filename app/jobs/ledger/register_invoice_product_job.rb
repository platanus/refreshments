class Ledger::RegisterInvoiceProductJob < ApplicationJob
  queue_as :ledger_transaction

  def perform(invoice_product)
    Ledger::RegisterInvoiceProduct.new(invoice_product).perform
    Ledger::RegisterInvoiceProductFee.new(invoice_product).perform
  end
end
