class UpdateInvoiceStatusJob < ApplicationJob
  TIME_OUT = 15.minutes
  SLEEP_TIME = 1
  queue_as :default

  def perform(r_hash)
    settled = listen_invoice(r_hash)
    puts "abajo settled"
    puts settled
    SettleInvoiceJob.perform_later(r_hash) if settled
    DispenseProductsJob.perform_later(r_hash) if settled
    # UpdateInvoiceStatusJob.perform_later(r_hash) if !settled
    ActionCable.server.broadcast 'invoices', settled: settled
  end

  private

  def listen_invoice(r_hash)
    settled = false
    start_time = Time.zone.now
    while !settled && start_time + TIME_OUT > Time.zone.now
      puts "in while"
      settled = InvoiceUtils.status(r_hash)
      sleep SLEEP_TIME
    end
    settled
  end
end
