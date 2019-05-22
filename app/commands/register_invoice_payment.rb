class RegisterInvoicePayment < PowerTypes::Command.new(:invoice)
  def perform
    return unless @invoice.settled

    @invoice.invoice_products.each do |invoice_product|
      Ledger::Transfer.for(
        from: debt_to_seller_account(invoice_product.user_product.user),
        to: lightning_account,
        countable: invoice_product,
        amount: invoice_product.product_price,
        date: @invoice.created_at
      )
    end
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
      accountable: Wallet.find(ENV.fetch("PLATANUS_WALLET_ID")),
      category: 'Wallet'
    )
  end
end
