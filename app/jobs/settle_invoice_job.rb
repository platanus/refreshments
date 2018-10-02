class SettleInvoiceJob < ApplicationJob
  queue_as :default

  def perform(r_hash)
    @r_hash = r_hash
    invoice&.update!(settled: true) unless invoice&.settled
  end

  private

  def invoice
    @invoice ||= Invoice.find_by(r_hash: @r_hash)
  end
end
