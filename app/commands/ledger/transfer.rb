class Ledger::Transfer < PowerTypes::Command.new(:from, :to, :amount, :countable, :date,
  :category)
  def perform
    ActiveRecord::Base.transaction do
      create_line_and_update_account(@from, -@amount)
      create_line_and_update_account(@to, @amount)
    end
  end

  private

  def line_params(account, amount)
    updated_balance = account.balance + amount
    {
      ledger_account: account, amount: amount, balance: updated_balance,
      accountable: @countable, date: @date, category: @category
    }
  end

  def update_account_lines_balances(account)
    last_line = account.ledger_lines.before_date(@date).sorted.last
    balance = last_line.nil? ? 0 : last_line.balance
    account.ledger_lines.after_date(@date).sorted.each do |line|
      balance = line.amount + balance
      line.update!(balance: balance)
    end
  end

  def create_line_and_update_account(account, amount)
    LedgerLine.create!(line_params(account, amount))
    update_account_lines_balances(account)
    last_line = account.ledger_lines.sorted.last
    account.balance = last_line.balance
    account.save!
  end
end
