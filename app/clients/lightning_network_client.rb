class LightningNetworkClient
  include HTTParty
  LND_HOST = ENV.fetch('LND_HOST')
  LND_PORT = ENV.fetch('LND_PORT')
  INVOICE_MACAROON = ENV.fetch('LND_INVOICE_MACAROON')

  base_uri "https://#{LND_HOST}:#{LND_PORT}/v1"

  def invoices
    check_success self.class.get("/invoices", headers: headers, verify: false)
  end

  def invoice(r_hash)
    check_success self.class.get("/invoice/#{r_hash}", headers: headers, verify: false)
  end

  def create_invoice(memo, amount)
    check_success self.class.post(
      "/invoices",
      body: { memo: memo, value: amount }.to_json,
      headers: headers,
      verify: false
    )
  end

  private

  def headers
    { "Grpc-Metadata-macaroon": INVOICE_MACAROON } if INVOICE_MACAROON.present?
  end

  def check_success(response)
    raise LightningNetworkClientError::ClientError, response unless response.success?

    response
  end
end
