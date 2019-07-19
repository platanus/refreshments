class Ledger::RegisterLightningNetworkWithdrawalNew < Ledger::BaseRegister
  def initialize(lightning_network_withdrawal)
    @accountable = lightning_network_withdrawal
    @category = 'new'
    @from_account = lightning_network_withdrawal.user.unconfirmed_withdrawal_funds
    @to_account = lightning_network_withdrawal.user.available_funds
    @date = lightning_network_withdrawal.created_at
    @amount_to_register = lightning_network_withdrawal.amount
  end
end
