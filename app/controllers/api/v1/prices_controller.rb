class Api::V1::PricesController < Api::V1::BaseController
  def satoshi_price
    return respond_with error: "No clp_price given" if params[:clp_price].nil?
    satoshi_price = GetPriceOnSatoshis.for(clp_price: params[:clp_price].to_i)
    respond_with satoshi_price: satoshi_price
  end
end
