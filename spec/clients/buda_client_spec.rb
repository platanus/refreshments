require 'rails_helper'

RSpec.describe BudaClient do
  def initialize_httparty
    allow(HTTParty).to receive(:post)
  end

  def initialize_buda_client
    buda_client = BudaClient.new
    allow(buda_client).to receive(:create_withdrawal_request_body).and_return('body')
    allow(buda_client).to receive(:headers).and_return('headers')
    buda_client.generate_withdrawal(10, 'address', true)
  end

  def initialize_context
    initialize_httparty
    initialize_buda_client
  end

  context 'generate withdrawall call' do
    before { initialize_context }

    it 'calls HTTParty with right params' do
      expect(HTTParty)
        .to have_received(:post)
        .with(
          "expected_base_url/currencies/btc/withdrawals",
          headers: 'headers',
          body: 'body'
        )
    end
  end
end
