class BudaClient
  include HTTParty
  base_uri "https://www.buda.com/api/v2"

  def quotation(market_id:, type:, amount:)
    self.class.post("/markets/#{market_id}/quotations", body: { type: type, amount: amount })
  end
end
