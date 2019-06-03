class PayInvoiceToUser < PowerTypes::Command.new(:invoice_hash, :user)
  def perform
    LightningNetworkWithdrawal.create(
      invoice_hash: invoice_hash,
      user_id: user.id
    )
  end
end
