class CreateInvoiceProducts < PowerTypes::Command.new(:invoice, :prices_hash, :products_hash)
  def perform
    validate_stock!
    create_invoice_products
  end

  private

  def validate_stock!
    @products_hash.each do |product_id, data|
      raise "Product doesn't have stock" unless product_has_stock(product_id.to_i, data['amount'])
    end
  end

  def product_has_stock(product_id, amount)
    user_product(product_id).stock >= amount
  end

  def create_invoice_products
    @invoice.invoice_products.create!(invoice_products_data)
  end

  def invoice_products_data
    @products_hash.each do |product_id, data|
      add_product(product_id.to_i, data['amount'])
    end
    invoice_products
  end

  def add_product(product_id, amount)
    amount.times do
      invoice_products.push(user_product_id: user_product(product_id).id)
    end
  end

  def invoice_products
    @invoice_products ||= []
  end

  def user_product(product_id)
    UserProduct.find_by(product_id: product_id, price: find_price(product_id))
  end

  def find_price(product_id)
    @prices_hash[product_id]
  end
end
