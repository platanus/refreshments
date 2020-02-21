class UpdateInvoiceStatusJob < ApplicationJob
  TIME_OUT = 15.minutes
  SLEEP_TIME = 1
  queue_as :default

  def perform(r_hash)
    settled = listen_invoice(r_hash)
    # puts "abajo settled"
    # puts settled
    SettleInvoiceJob.perform_later(r_hash) if settled
    DispenseProductsJob.perform_later(r_hash) if settled
    # UpdateInvoiceStatusJob.perform_later(r_hash) if !settled
    ActionCable.server.broadcast 'invoices', settled: settled
  end

  private

  def listen_invoice(r_hash)
    # settled = false
    settled = InvoiceUtils.status(r_hash)
    puts "abajo imprime r_hash"
    puts r_hash
    start_time = Time.zone.now
    while !settled && start_time + TIME_OUT > Time.zone.now
      puts "in while"
      puts "abajo imprime settled antes de llamar a InvoiceUtils.status"
      puts settled
      settled = InvoiceUtils.status(r_hash)
      puts "abajo imprime settled luego de llamar a InvoiceUtils.statu"
      puts settled
      sleep SLEEP_TIME
    end
    puts "sale del while"
    puts settled
    settled
  end
end
