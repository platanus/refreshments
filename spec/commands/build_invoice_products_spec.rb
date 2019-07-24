require 'rails_helper'

describe BuildInvoiceProducts do
  let(:amount) { 1 }

  def set_shopping_cart_item(user_product)
    @shopping_cart_item = ShoppingCartItem.new(user_product.id, amount)
  end

  def perform
    described_class.for(shopping_cart_item: @shopping_cart_item)
  end

  context "with amount = 1 and user_product with stock for this product" do
    before do
      @user_product = create(:user_product, stock: 10)
      set_shopping_cart_item(@user_product)
    end

    it { expect(perform.first.user_product).to eq(@user_product) }
    it { expect(perform.first.product_price).to eq(@user_product.price) }
  end

  context "with amount = 1 and user_product without stock for this product" do
    before do
      @user_product = create(:user_product, stock: 0)
      set_shopping_cart_item(@user_product)
    end

    it { expect(perform.count).to eq(0) }
  end

  context "with amount = 2 and user_product has 1 item in stock" do
    let(:amount) { 2 }

    before do
      @user_product = create(:user_product, stock: 1, price: 1000)
      set_shopping_cart_item(@user_product)
    end

    it { expect(perform.count).to eq(0) }
  end

  context "with amount = 2 and user_product with stock" do
    let(:amount) { 2 }

    before do
      @user_product = create(:user_product, stock: 2, price: 1000)
      set_shopping_cart_item(@user_product)
    end

    it { expect(perform.count).to eq(2) }
    it { expect(perform.first.user_product).to eq(@user_product) }
    it { expect(perform.first.product_price).to eq(@user_product.price) }
  end
end
