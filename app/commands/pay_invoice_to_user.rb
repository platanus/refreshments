class PayInvoiceToUser < PowerTypes::Command.new(:invoice_hash, :user)
  def perform
    LightningNetworkWithdrawal.create(
      invoice_hash: @invoice_hash,
      user_id: @user.id,
      amount: decoded_invoice['num_satoshis'].to_i,
      memo: decoded_invoice['description']
    )
  end

  private

  def decoded_invoice
    @decoded_invoice ||= lightning_network_client
                         .decode_payment_request(@invoice_hash)
  end

  def lightning_network_client
    @lightning_network_client ||= LightningNetworkClient.new
  end
end
