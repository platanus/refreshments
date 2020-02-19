class UpdateInvoiceStatusJob < ApplicationJob
  TIME_OUT = 5.minutes
  queue_as :default

  def perform(r_hash)
    date_created = Invoice.find_by(r_hash: r_hash).created_at
    settled = InvoiceUtils.status(r_hash)
    lapse = date_created + TIME_OUT
    t_now = Time.zone.now
    SettleInvoiceJob.perform_later(r_hash) if settled
    DispenseProductsJob.perform_later(r_hash) if settled
    UpdateInvoiceStatusJob.set(wait: 1.second).perform_later(r_hash) if !settled && (t_now < lapse)
    ActionCable.server.broadcast 'invoices', settled: settled
  end
end
