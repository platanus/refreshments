class SettleInvoiceJob < ApplicationJob
  queue_as :default

  def perform(r_hash)
    @r_hash = r_hash
    unless invoice.nil? || invoice&.settled
      invoice&.update!(settled: true)
      DoorClient.new.open_door
    end
  end

  private

  def invoice
    @invoice ||= Invoice.find_by(r_hash: @r_hash)
  end
end
