class LedgerAccountsController < ApplicationController
  before_action :authenticate_user!

  def index
    @ledger_account = current_user.available_funds
    @ledger_lines = current_user.available_funds.ledger_lines.sorted_desc
    @total_balance = current_user.available_funds.balance
  end
end
