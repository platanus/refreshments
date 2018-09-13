require 'rails_helper'

describe CreateInvoice do
  let(:product_a) { create(:product, name: "Coca Cola", price: 500) }
  let(:product_b) { create(:product, name: "Sprite", price: 650) }

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
end
