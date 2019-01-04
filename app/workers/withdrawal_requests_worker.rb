class WithdrawalRequestsWorker
  include Sidekiq::Worker

  CREATE_SUCCESS_CODE = 201

  def perform(withdrawal_id)
    @withdrawal = Withdrawal.find_by!(id: withdrawal_id)
    @response = CreateBTCWithdrawal.for(withdrawal: @withdrawal)
    handle_response
  end

  def handle_response
    return @withdrawal.reject! if @response.code != CREATE_SUCCESS_CODE
    @request_errors = JSON.parse(@response.body)['withdrawal']['errors']
    return @withdrawal.reject! if @request_errors && @request_errors.any?
    @withdrawal.confirm!
  end
end
