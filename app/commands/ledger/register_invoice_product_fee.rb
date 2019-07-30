class Ledger::RegisterInvoiceProductFee < Ledger::BaseRegister
  def initialize(invoice_product)
    @accountable = invoice_product
    @category = 'fee'
    @from_account = business_user.available_funds
    @to_account = invoice_product.user_product.user.available_funds
    @date = invoice.created_at
    @amount_to_register = invoice.settled ? invoice_product.product_fee : 0
  end

  private

  def business_user
    User.find(ENV.fetch("BUSINESS_USER_ID"))
  end

  def invoice
    @accountable.invoice
  end
end
