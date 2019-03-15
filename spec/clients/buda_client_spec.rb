require 'rails_helper'

RSpec.describe BudaClient do
  let(:buda_client) { BudaClient.new }

  before do
    stub_const('BudaClient::BASE_URI', 'stubbed_base_uri')
    stub_const('BudaClient::API_SECRET', 'stubbed_api_secret')
    stub_const('BudaClient::API_KEY', 'stubbed_api_key')
  end

  describe '#generate_withdrawal' do
    def valid_body?(raw_body)
      parsed_body = JSON.parse(raw_body)
      [
        parsed_body['amount'] == 10,
        parsed_body['withdrawal_data']['target_address'] == 'address'
      ].all?
    end

    def valid_headers?(headers)
      [
        headers['X-SBTC-APIKEY'] == 'stubbed_api_key',
        headers['X-SBTC-NONCE'].present?,
        headers['X-SBTC-SIGNATURE'].present?
      ].all?
    end

    it 'calls the API with correct params' do
      expect(HTTParty).to receive(:post)
        .with(
          satisfy { |url|  url == 'stubbed_base_uri/currencies/btc/withdrawals' },
          satisfy { |req| valid_body?(req[:body]) && valid_headers?(req[:headers]) }
        )

      buda_client.generate_withdrawal(10, 'address', true)
    end
  end
end
