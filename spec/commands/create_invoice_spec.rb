require 'rails_helper'

describe CreateInvoice do
  let(:user) { create(:user, name: "test_user", email: "test@email.com", password: "123456")}

  let(:product_a) { create(:product, name: "Coca Cola", price: 500, user: user) }
  let(:product_b) { create(:product, name: "Sprite", price: 650, user: user) }

  let!(:product_a_id) { product_a.id }
  let!(:product_b_id) { product_b.id }

  let(:lightning_network_client) { double }

  let(:memo) { "Memo" }
  let(:products_hash) { { product_a_id => 1, product_b_id => 1 } }

  def perform
    described_class.for(memo: memo, products_hash: products_hash)
  end

  def mock_lightning_network_client
    allow_any_instance_of(described_class).to receive(:lightning_network_client)
      .and_return(lightning_network_client)
    allow(lightning_network_client).to receive(:create_invoice)
      .and_return(
        "r_hash" => "r_hash", "payment_request" => "payment_request", "add_index" => "add_index"
      )
  end

  def mock_price_on_satoshis
    allow(GetPriceOnSatoshis).to receive(:for) do |args|
      args[:clp_price] * 10_000
    end
  end

  before do
    mock_lightning_network_client
    mock_price_on_satoshis
  end

  it { expect(perform).to be_a(Invoice) }
  it "calls GetPriceOnSatoshis with correct clp_price" do
    expect(GetPriceOnSatoshis).to receive(:for).with(clp_price: 1_150)

    perform
  end

  context "with 0 satoshis" do
    let(:products_hash) { { product_a_id.to_i + product_b_id.to_i => 1 } }

    it "raises satoshi amount error" do
      expect { perform }.to raise_error("Invalid satoshi amount")
    end
  end

  context "with 1 product" do
    let(:products_hash) { { product_a_id => 1 } }
    it "creates exactly 1 invoice product with correct invoice and product" do
      new_invoice = perform
      expect(InvoiceProduct.count).to eq(1)
      expect(InvoiceProduct.first.product.id).to eq(product_a.id)
      expect(InvoiceProduct.first.invoice.id).to eq(new_invoice.id)
    end
  end

  context "with more than 1 equal products" do
    let(:products_hash) { { product_a_id => 3 } }
    it "creates exactly 3 invoice products with correct invoice and product" do
      new_invoice = perform
      expect(InvoiceProduct.count).to eq(3)
      InvoiceProduct.all.each do |invoice_product|
        expect(invoice_product.product.id).to eq(product_a.id)
        expect(invoice_product.invoice.id).to eq(new_invoice.id)
      end
    end
  end

  context "with more than 1 different products" do
    let(:products_hash) { { product_a_id => 3, product_b_id => 4 } }
    it "creates exactly 7 invoice products with correct invoice and product each" do
      new_invoice = perform
      expect(InvoiceProduct.count).to eq(7)
      expect(product_a.invoice_products.count).to eq(3)
      expect(product_b.invoice_products.count).to eq(4)
      expect(new_invoice.invoice_products.count).to eq(7)
    end
  end

end
