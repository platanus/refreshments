class Ledger::RegisterWithdrawal < Ledger::BaseRegister
  def initialize(withdrawal)
    @accountable = withdrawal
    @category = 'confirmed'
    @from_account = ln_node.available_funds
    @to_account = withdrawal.user.available_funds
    @date = withdrawal.created_at
    @amount_to_register = withdrawal.confirmed? ? withdrawal.amount : 0
  end

  private

  def ln_node
    Wallet.find(ENV.fetch("PLATANUS_WALLET_ID"))
  end
end
