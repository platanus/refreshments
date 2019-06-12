require 'rails_helper'

describe BuildInvoiceProducts do
  let(:amount) { 1 }
  let(:product) { create(:product) }
  let(:shopping_cart_item) { ShoppingCartItem.new(product.id, amount) }

  def perform
    described_class.for(shopping_cart_item: shopping_cart_item)
  end

  context "with amount = 1 and only 1 user_product with stock for this product" do
    before do
      @user_product = create(:user_product, product: product, stock: 10)
    end

    it { expect(perform.first.user_product).to eq(@user_product) }
    it { expect(perform.first.product_price).to eq(@user_product.price) }
  end

  context "with amount = 1 and only 1 user_product without stock for this product" do
    before do
      @user_product = create(:user_product, product: product, stock: 0)
    end

    it { expect(perform.count).to eq(0) }
  end

  context "with amount = 1 and only no user_product for this product" do
    it { expect(perform.count).to eq(0) }
  end

  context "with amount = 1 and 2 user_product with stock and different price" do
    before do
      @user_product = create(:user_product, product: product, stock: 10, price: 2000)
      @best_user_product = create(:user_product, product: product, stock: 10, price: 1000)
    end

    it { expect(perform.first.user_product).to eq(@best_user_product) }
    it { expect(perform.first.product_price).to eq(@best_user_product.price) }
  end

  context "with amount = 1 and 2 user_product and the cheapest has no stock" do
    before do
      @best_user_product = create(:user_product, product: product, stock: 10, price: 2000)
      @user_product = create(:user_product, product: product, stock: 0, price: 1000)
    end

    it { expect(perform.first.user_product).to eq(@best_user_product) }
    it { expect(perform.first.product_price).to eq(@best_user_product.price) }
  end

  context "with amount = 2 and user_product for this product has 1 item in stock" do
    let(:amount) { 2 }

    before do
      @user_product = create(:user_product, product: product, stock: 1, price: 1000)
    end

    it { expect(perform.count).to eq(0) }
  end

  context "with amount = 2 and user_product with stock" do
    let(:amount) { 2 }

    before do
      @user_product = create(:user_product, product: product, stock: 2, price: 1000)
    end

    it { expect(perform.count).to eq(2) }
    it { expect(perform.first.user_product).to eq(@user_product) }
    it { expect(perform.first.product_price).to eq(@user_product.price) }
  end
end
