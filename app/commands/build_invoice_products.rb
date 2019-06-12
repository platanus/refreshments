class BuildInvoiceProducts < PowerTypes::Command.new(:shopping_cart_item)
  def perform
    return [] if best_user_product.nil?

    Array.new(@shopping_cart_item.amount).map { build_invoice_product }
  end

  private

  def build_invoice_product
    InvoiceProduct.new(user_product: best_user_product, product_price: best_user_product.price)
  end

  def best_user_product
    @best_user_product ||= product.user_products
                                  .where('stock >= ?', min_stock)
                                  .order(price: :asc).first
  end

  def product
    @shopping_cart_item.product
  end

  def min_stock
    @shopping_cart_item.amount
  end
end
