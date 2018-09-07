class GetPriceOnSatoshis < PowerTypes::Command.new(:clp_price)
  def perform
    satoshi_price
  end

  private

  def satoshi_price
    if !@clp_price.zero? && btc_price.zero?
      raise BudaClientError::BadResponseError, "Non zero clp price and bad response"
    end
    (btc_price * 100_000_000).round
  end

  def btc_price
    @btc_price ||= begin
      quotation_response&.[]("quotation")&.[]("base_balance_change")&.[](0)&.to_f&.abs || 0
    end
  end

  def quotation_response
    @quotation_response ||= buda_client.quotation(
      market_id: "btc-clp", type: "ask_given_earned_quote", amount: @clp_price
    )
  end

  def buda_client
    @buda_client ||= BudaClient.new
  end
end
