require 'rails_helper'

describe CreateInvoice do
  let(:amount) { 1 }
  let(:product_bon_bon) { create(:product, name: 'Bon o Bon') }
  let(:product_coca_cola) { create(:product, name: 'Coca Cola') }
  let(:invoice_product) { build(:invoice_product, product_price: 1000) }

  def perform
    described_class.for(shopping_cart_items: shopping_cart_items)
  end

  before do
    allow_any_instance_of(LightningNetworkClient).to receive(:create_invoice)
      .with(memo, total_satoshis)
      .and_return('payment_request' => 'request', 'r_hash' => 'hash')
  end

  context 'with one shopping_cart_item and a valid invoice_product' do
    let(:shopping_cart_items) { [ShoppingCartItem.new(product_bon_bon.id, amount)] }
    let(:memo) { '1 x Bon o Bon' }
    let(:total_satoshis) { 4050 }

    before do
      shopping_cart_items.each do |shopping_cart_item|
        allow(BuildInvoiceProducts).to receive(:for).with(shopping_cart_item: shopping_cart_item)
                                                    .and_return(invoice_product)
      end
      allow(GetPriceOnSatoshis).to receive(:for).with(clp_price: 1000).and_return(4050)
    end

    it { expect { perform }.to change { Invoice.all.count }.by(1) }
    it { expect(perform.memo).to eq('1 x Bon o Bon') }
    it { expect(perform.clp).to eq(1000) }
    it { expect(perform.amount).to eq(4050) }
    it { expect(perform.r_hash).to eq('hash') }
    it { expect(perform.payment_request).to eq('request') }
    it { expect(perform.invoice_products.first).to eq(invoice_product) }
  end

  context 'with one shopping_cart_item and amount = 2' do
    let(:amount) { 2 }
    let(:shopping_cart_items) { [ShoppingCartItem.new(product_bon_bon.id, amount)] }
    let(:memo) { '2 x Bon o Bon' }
    let(:total_satoshis) { 8100 }

    before do
      shopping_cart_items.each do |shopping_cart_item|
        allow(BuildInvoiceProducts).to receive(:for).with(shopping_cart_item: shopping_cart_item)
                                                    .and_return(Array.new(2, invoice_product))
      end
      allow(GetPriceOnSatoshis).to receive(:for).with(clp_price: 2000).and_return(8100)
    end

    it { expect { perform }.to change { Invoice.all.count }.by(1) }
    it { expect(perform.memo).to eq('2 x Bon o Bon') }
    it { expect(perform.clp).to eq(2000) }
    it { expect(perform.amount).to eq(8100) }
    it { expect(perform.r_hash).to eq('hash') }
    it { expect(perform.payment_request).to eq('request') }
    it { expect(perform.invoice_products.size).to eq(2) }
    it { expect(perform.invoice_products.first).to eq(invoice_product) }
  end

  context 'with two shopping_cart_item and valid invoice_products' do
    let(:shopping_cart_items) do
      [
        ShoppingCartItem.new(product_bon_bon.id, amount),
        ShoppingCartItem.new(product_coca_cola.id, amount)
      ]
    end
    let(:memo) { '1 x Bon o Bon, 1 x Coca Cola' }
    let(:total_satoshis) { 8100 }

    before do
      shopping_cart_items.each do |shopping_cart_item|
        allow(BuildInvoiceProducts).to receive(:for).with(shopping_cart_item: shopping_cart_item)
                                                    .and_return(invoice_product)
      end
      allow(GetPriceOnSatoshis).to receive(:for).with(clp_price: 2000).and_return(8100)
    end

    it { expect { perform }.to change { Invoice.all.count }.by(1) }
    it { expect(perform.memo).to eq('1 x Bon o Bon, 1 x Coca Cola') }
    it { expect(perform.clp).to eq(2000) }
    it { expect(perform.amount).to eq(8100) }
    it { expect(perform.r_hash).to eq('hash') }
    it { expect(perform.payment_request).to eq('request') }
    it { expect(perform.invoice_products.size).to eq(2) }
    it { expect(perform.invoice_products.first).to eq(invoice_product) }
  end

  context 'with invalid amount of invoice_products' do
    let(:amount) { 2 }
    let(:shopping_cart_items) { [ShoppingCartItem.new(product_bon_bon.id, amount)] }
    let(:memo) { '2 x Bon o Bon' }
    let(:total_satoshis) { 8100 }

    before do
      shopping_cart_items.each do |shopping_cart_item|
        allow(BuildInvoiceProducts).to receive(:for).with(shopping_cart_item: shopping_cart_item)
                                                    .and_return(invoice_product)
      end
    end

    it { expect { perform }.to change { Invoice.all.count }.by(0) }
    it { expect(perform).to be_falsy }
  end
end
