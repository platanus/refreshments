class LedgerAccountsController < ApplicationController
  before_action :authenticate_user!

  def index
    @ledger_account = LedgerAccount.find_by(accountable_id: current_user.id)
    @ledger_lines = LedgerLine.where(ledger_account_id: @ledger_account.id).sorted_desc
    @total_balance = @ledger_lines.empty? ? 0 : @ledger_lines.first.balance
    @line_id_to_product_data_hash = line_id_to_product_data_hash
  end

  private

  def line_id_to_product_data_hash
    @ledger_lines
      .where(accountable_type: 'InvoiceProduct')
      .map { |line| import_product_data(line) }
      .to_h
  end

  def import_product_data(line)
    user_product = UserProduct
                   .joins(:invoice_products)
                   .where(invoice_products: { id: line.accountable_id })
                   .last
    product = Product.find(user_product.product_id)
    [line.id, [product.name, user_product.price]]
  end
end
