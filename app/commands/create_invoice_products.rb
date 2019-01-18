class CreateInvoiceProducts < PowerTypes::Command.new(:invoice, :prices_hash, :products_hash)
  def perform
    create_invoice_products
  end

  private

  def create_invoice_products
    @invoice.invoice_products.create!(invoice_products_data)
  end

  def invoice_products_data
    @products_hash.each do |product_id, data|
      add_product(product_id, data['amount'])
    end
    invoice_products
  end

  def add_product(product_id, amount)
    price = @prices_hash[product_id]
    amount.times do
      invoice_products.push(user_product_id: user_product_id(product_id, price))
    end
  end

  def invoice_products
    @invoice_products ||= []
  end

  def user_product_id(product_id, price)
    UserProduct.find_by(product_id: product_id, price: price).id
  end
end
