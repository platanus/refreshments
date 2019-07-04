class ProcessLightningNetworkWithdrawal < PowerTypes::Command.new(:lightning_withdrawal)
  def perform
    if enough_funds?
      process_payment
    else
      reject_payment
    end
  end

  private

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
