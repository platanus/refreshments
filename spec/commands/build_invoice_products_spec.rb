require 'rails_helper'

describe BuildInvoiceProducts do
  let(:amount) { 1 }

  def set_shopping_cart_item(product)
    @shopping_cart_item = ShoppingCartItem.new(product.id, amount)
  end

  def perform
    described_class.for(shopping_cart_item: @shopping_cart_item)
  end

  context "with amount = 1 and product with stock for this product" do
    before do
      @product = create(:product, stock: 10)
      set_shopping_cart_item(@product)
    end

    it { expect(perform.first.product).to eq(@product) }
    it { expect(perform.first.product_price).to eq(@product.price) }
  end

  context "with amount = 1 and product without stock for this product" do
    before do
      @product = create(:product, stock: 0)
      set_shopping_cart_item(@product)
    end

    it { expect(perform.count).to eq(0) }
  end

  context "with amount = 2 and product has 1 item in stock" do
    let(:amount) { 2 }

    before do
      @product = create(:product, stock: 1, price: 1000)
      set_shopping_cart_item(@product)
    end

    it { expect(perform.count).to eq(0) }
  end

  context "with amount = 2 and product with stock" do
    let(:amount) { 2 }

    before do
      @product = create(:product, stock: 2, price: 1000)
      set_shopping_cart_item(@product)
    end

    it { expect(perform.count).to eq(2) }
    it { expect(perform.first.product).to eq(@product) }
    it { expect(perform.first.product_price).to eq(@product.price) }
  end
end
