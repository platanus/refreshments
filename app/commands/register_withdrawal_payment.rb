class RegisterWithdrawalPayment < PowerTypes::Command.new(:withdrawal)
  def perform
    return unless @withdrawal.confirmed?

    Ledger::Transfer.for(
      from: lightning_account,
      to: debt_to_seller_account(@withdrawal.user),
      countable: @withdrawal,
      amount: @withdrawal.amount,
      date: @withdrawal.created_at
    )
  end

  private

  def debt_to_seller_account(user)
    LedgerAccount.find_or_create_by!(
      accountable: user,
      category: 'DebtToSellers'
    )
  end

  def lightning_account
    LedgerAccount.find_or_create_by!(
      accountable: Wallet.find(ENV.fetch("PLATANUS_WALLET_ID")), # nodo de platanus
      category: 'Wallet'
    )
  end
end
