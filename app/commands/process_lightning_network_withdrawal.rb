class ProcessLightningNetworkWithdrawal < PowerTypes::Command.new(:lightning_withdrawal)
  def perform
    decode_invoice

    if enough_funds?
      process_payment
    else
      reject_payment
    end
  end

  private

  def decode_invoice
    decoded_invoice = lightning_network_client
                      .decode_payment_request(@lightning_withdrawal.invoice_hash)
    @lightning_withdrawal.amount = decoded_invoice['num_satoshis'].to_i
    @lightning_withdrawal.memo = decoded_invoice['description']
    @lightning_withdrawal.save!
  end

  def enough_funds?
    withdrawal_user_withdrawable_amount >= withdrawal_amount
  end

  def process_payment
    ActiveRecord::Base.transaction do
      @lightning_withdrawal.confirm!
      RegisterLightningNetworkWithdrawalPayment.for(lightning_withdrawal: @lightning_withdrawal)
      lightning_network_client.transaction(@lightning_withdrawal.invoice_hash)
    end
  end

  def reject_payment
    @lightning_withdrawal.reject!
  end

  def withdrawal_user_withdrawable_amount
    @withdrawal_user_withdrawable_amount ||= User.find(@lightning_withdrawal.user_id)
                                                 .withdrawable_amount
  end

  def withdrawal_amount
    @withdrawal_amount ||= @lightning_withdrawal.amount
  end

  def lightning_network_client
    @lightning_network_client ||= LightningNetworkClient.new
  end
end
