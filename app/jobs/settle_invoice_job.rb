class SettleInvoiceJob < ApplicationJob
  queue_as :default

  def perform(r_hash)
    puts "it entered SettleInvoiceJob"
    @r_hash = r_hash
    unless invoice.nil? || invoice&.settled
      invoice&.update!(settled: true)
      invoice.invoice_products.each(&:discount_stock)
      DoorClient.new.open_door
    end
  end

  private

  def invoice
    @invoice ||= Invoice.find_by(r_hash: @r_hash)
  end
end
