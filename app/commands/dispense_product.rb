class DispenseProduct < PowerTypes::Command.new(:invoice_product)
  SUCCESS = 200

  def perform
    ensure_not_dispensed_product!

    response = HTTParty.get(url, headers: headers)
    if response.code == SUCCESS
      @invoice_product.update(dispensed: true)
    else
      raise "Unable to dispense Invoice Product #{@invoice_product.id}"
    end
  end

  private

  def headers
    {
      'X-Refreshments-Event' => 'dispense'
    }
  end

  def ensure_not_dispensed_product!
    if @invoice_product.dispensed?
      raise "Invoice Product #{@invoice_product.id} was already dispensed"
    end
  end

  def url
    @invoice_product.product.webhook_url
  end
end
