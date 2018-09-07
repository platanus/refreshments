require 'rails_helper'

describe GetPriceOnSatoshis do
  let(:buda_client) { double }
  let(:clp_price_) { 650 }
  let(:quotation_response) do
    {
      "quotation" => {
        "amount" => ["650.0", "CLP"],
        "limit" => nil,
        "type" => "ask_given_earned_quote",
        "order_amount" => ["0.00014713", "BTC"],
        "base_exchanged" => ["0.00014713", "BTC"],
        "quote_exchanged" => ["655.24", "CLP"],
        "base_balance_change" => ["-0.00014713", "BTC"],
        "quote_balance_change" => ["650.0", "CLP"],
        "fee" => ["5.24", "CLP"],
        "incomplete" => false
      }
    }
  end

  def perform(clp_price: clp_price_)
    described_class.for(clp_price: clp_price)
  end

  def mock_buda_client
    allow_any_instance_of(described_class).to receive(:buda_client).and_return(buda_client)
    allow(buda_client).to receive(:quotation).with(hash_including(amount: clp_price_))
      .and_return(quotation_response)
  end

  before do
    mock_buda_client
  end

  it "returns expected price" do
    expect(perform).to eq(14713)
  end

  context "with bad response" do
    let(:quotation_response) { { "error" => "Bad Response" } }

    it "raises error" do
      expect { perform }.to raise_error(
        BudaClientError::BadResponseError, "Non zero clp price and bad response"
      )
    end
  end
end
