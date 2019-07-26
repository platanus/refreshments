class ShoppingCartItem
  attr_accessor :user_product, :amount

  def initialize(user_product_id, amount)
    @user_product = UserProduct.find(user_product_id)
    @amount = amount
  end
end
