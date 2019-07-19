class Ledger::RegisterLightningNetworkWithdrawalFailed < Ledger::BaseRegister
  def initialize(lightning_network_withdrawal)
    @accountable = lightning_network_withdrawal
    @category = 'failed'
    @from_account = lightning_network_withdrawal.user.available_funds
    @to_account = lightning_network_withdrawal.user.unconfirmed_withdrawal_funds
    @date = lightning_network_withdrawal.created_at
    @amount_to_register = failed? ? lightning_network_withdrawal.amount : 0
  end

  private

  def failed?
    @accountable.failed?
  end
end
