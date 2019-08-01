class BuildInvoiceProducts < PowerTypes::Command.new(:shopping_cart_item)
  def perform
    return [] if product_without_stock?

    Array.new(@shopping_cart_item.amount).map { build_invoice_product }
  end

  private

  def build_invoice_product
    InvoiceProduct.new(
      product: product,
      product_price: product.price,
      fee_rate: product.fee_rate
    )
  end

  def product_without_stock?
    product.stock < min_stock
  end

  def product
    @product ||= @shopping_cart_item.product
  end

  def min_stock
    @shopping_cart_item.amount
  end
end
