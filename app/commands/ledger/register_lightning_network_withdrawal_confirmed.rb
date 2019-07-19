class Ledger::RegisterLightningNetworkWithdrawalConfirmed < Ledger::BaseRegister
  def initialize(lightning_network_withdrawal)
    @accountable = lightning_network_withdrawal
    @category = 'confirmed'
    @from_account = ln_node.available_funds
    @to_account = lightning_network_withdrawal.user.unconfirmed_withdrawal_funds
    @date = lightning_network_withdrawal.created_at
    @amount_to_register = confirmed? ? lightning_network_withdrawal.amount : 0
  end

  private

  def ln_node
    Wallet.find(ENV.fetch("PLATANUS_WALLET_ID"))
  end

  def confirmed?
    @accountable.confirmed?
  end
end
