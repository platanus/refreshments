class ShoppingCartItem
  attr_accessor :product, :amount

  def initialize(product_id, amount)
    @product = Product.find(product_id)
    @amount = amount
  end
end
