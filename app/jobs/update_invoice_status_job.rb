class UpdateInvoiceStatusJob < ApplicationJob
  queue_as :default

  def perform(r_hash)
    r_hash_decoded = URI.decode(r_hash)
    settled = InvoiceUtils.status(r_hash_decoded)
    SettleInvoiceJob.perform_later(r_hash_decoded) if settled
    DispenseProductsJob.perform_later(r_hash_decoded) if settled
    UpdateInvoiceStatusJob.perform_later(r_hash) if !settled
    ActionCable.server.broadcast 'invoices', settled: settled
    respond_with settled: settled
  end
end
