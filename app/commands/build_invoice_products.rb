class BuildInvoiceProducts < PowerTypes::Command.new(:shopping_cart_item)
  def perform
    return [] if user_product_without_stock?

    Array.new(@shopping_cart_item.amount).map { build_invoice_product }
  end

  private

  def build_invoice_product
    InvoiceProduct.new(
      user_product: user_product,
      product_price: user_product.price,
      fee_rate: user_product.fee_rate
    )
  end

  def user_product_without_stock?
    user_product.stock < min_stock
  end

  def user_product
    @user_product ||= @shopping_cart_item.user_product
  end

  def min_stock
    @shopping_cart_item.amount
  end
end
