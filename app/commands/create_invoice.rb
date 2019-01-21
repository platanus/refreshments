class CreateInvoice < PowerTypes::Command.new(:memo, :products_hash)
  def perform
    Invoice.transaction do
      validate_total_satoshis!
      create_invoice
      create_invoice_products
    end
    @new_invoice
  end

  private

  def validate_total_satoshis!
    raise 'Invalid satoshi amount' unless invoice_total_satoshis.positive?
  end

  def invoice_total_satoshis
    @invoice_total_satoshis ||= GetPriceOnSatoshis.for(clp_price: invoice_total_clp)
  end

  def invoice_total_clp
    @invoice_total_clp ||= begin
      @products_hash.map do |product_id, data|
        (prices_hash[product_id.to_i] || 0) * data['amount']
      end.inject(:+) || 0
    end
  end

  def prices_hash
    @prices_hash ||= GetPricesHash.for(products_hash: @products_hash)
  end

  def lightning_network_client
    @lightning_network_client ||= LightningNetworkClient.new
  end

  def invoice_response
    @invoice_response ||= lightning_network_client.create_invoice(@memo, invoice_total_satoshis)
  end

  def create_invoice
    @new_invoice = Invoice.create!(
      amount: invoice_total_satoshis,
      clp: invoice_total_clp,
      memo: @memo,
      payment_request: invoice_response['payment_request'],
      r_hash: invoice_response['r_hash']
    )
  end

  def create_invoice_products
    CreateInvoiceProducts.for(
      invoice: @new_invoice,
      prices_hash: prices_hash,
      products_hash: @products_hash
    )
  end
end
