class LightningNetworkClient
  include HTTParty
  LN_BASE_URL = ENV.fetch("LN_BASE_URL")

  base_uri LN_BASE_URL

  def invoices
    self.class.get("/invoices", headers: headers, verify: false)
  end

  def invoice(r_hash)
    self.class.get("/invoice/#{r_hash}", headers: headers, verify: false)
  end

  def create_invoice(memo, satoshis)
    self.class.post(
      "/invoices",
      body: { memo: memo, value: satoshis }.to_json,
      headers: headers,
      verify: false
    )
  end

  private

  def headers
    { "Grpc-Metadata-macaroon": macaroon_data }
  end

  def macaroon_data
    @macaroon_data ||= ENV.fetch("INVOICE_MACAROON")
  end

  def config
    @config ||= LightningNodeConfig.last
  end
end
