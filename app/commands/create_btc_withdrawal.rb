class CreateBTCWithdrawal < PowerTypes::Command.new(:withdrawal)
  def perform
    buda_client.generate_withdrawal(btc_amount, btc_address)
  end

  private

  def buda_client
    @buda_client ||= BudaClient.new
  end

  def btc_amount
    @withdrawal.btc_amount
  end

  def btc_address
    @withdrawal.btc_address
  end
end
