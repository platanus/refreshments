class Ledger::RegisterInvoiceProduct < Ledger::BaseRegister
  def initialize(invoice_product)
    @accountable = invoice_product
    @category = 'settled'
    @from_account = invoice_product.product.user.available_funds
    @to_account = ln_node.available_funds
    @date = invoice.created_at
    @amount_to_register = invoice.settled ? invoice_product.product_price : 0
  end

  private

  def ln_node
    Wallet.find(ENV.fetch("PLATANUS_WALLET_ID"))
  end

  def invoice
    @accountable.invoice
  end
end
