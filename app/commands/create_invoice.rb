class CreateInvoice < PowerTypes::Command.new(:shopping_cart_items)
  def perform
    return false unless check_stock

    invoice = Invoice.create(
      memo: memo,
      clp: total_clp,
      amount: total_satoshis
    )
    invoice.invoice_products.push(*invoice_products)
    invoice.r_hash = invoice_response['r_hash']
    invoice.payment_request = invoice_response['payment_request']
    invoice.save!
    invoice
  end

  private

  def memo
    @shopping_cart_items.map do |shopping_cart_item|
      "#{shopping_cart_item.amount} x #{shopping_cart_item.product.name}"
    end.join(', ')
  end

  def total_clp
    @total_clp ||= invoice_products.pluck(:product_price).sum
  end

  def total_satoshis
    @total_satoshis ||= GetPriceOnSatoshis.for(clp_price: total_clp)
  end

  def invoice_products
    @invoice_products ||= begin
      invoice_products = []
      @shopping_cart_items.each do |shopping_cart_item|
        invoice_products.push(*BuildInvoiceProducts.for(shopping_cart_item: shopping_cart_item))
      end
      invoice_products
    end
  end

  def check_stock
    invoice_products.count == @shopping_cart_items.reduce(0) { |acc, item| acc + item.amount }
  end

  def lightning_network_client
    @lightning_network_client ||= LightningNetworkClient.new
  end

  def invoice_response
    @invoice_response ||= lightning_network_client.create_invoice(memo, total_satoshis)
  end
end
