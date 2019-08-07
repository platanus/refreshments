class Api::V1::StatisticsController < Api::V1::BaseController
  def fee_balance
    respond_with fee_balance: GetFeeBalance.for
  end
end
