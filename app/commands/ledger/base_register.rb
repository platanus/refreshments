class Ledger::BaseRegister
  attr_reader :accountable, :category, :from_account, :to_account, :amount_to_register, :date

  def perform
    return if amount_to_register.nil? || unregistered_amount.zero?

    Ledger::Transfer.for(
      from: from_account,
      to: to_account,
      amount: unregistered_amount,
      date: date,
      accountable: accountable,
      category: category
    )
  end

  private

  def unregistered_amount
    @unregistered_amount ||= amount_to_register - registered_amount
  end

  def registered_amount
    @registered_amount ||= LedgerLine.where(
      accountable: accountable, ledger_account: to_account, category: category
    ).sum(&:amount)
  end
end
