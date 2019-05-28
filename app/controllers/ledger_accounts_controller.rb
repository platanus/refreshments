class LedgerAccountsController < ApplicationController
  before_action :authenticate_user!

  def index
    @ledger_account = LedgerAccount.find_by_accountable_id(current_user.id)
    @ledger_lines = LedgerLine.where(ledger_account_id: @ledger_account.id).sorted_desc
    @total_balance = @ledger_lines.empty? ? 0 : @ledger_lines.first.balance
    line_id_to_product_data_hash
  end

  private

  def line_id_to_product_data_hash
    sales_lines = @ledger_lines.where(accountable_type: 'InvoiceProduct')
    @line_id_to_product_data_hash = sales_lines.map { |line| import_product_data(line) }.to_h
  end

  def import_product_data(line)
    invoice_product = InvoiceProduct.find(line.accountable_id)
    user_product = UserProduct.find(invoice_product.user_product_id)
    product = Product.find(user_product.product_id)
    [line.id, [product.name, user_product.price]]
  end
end
