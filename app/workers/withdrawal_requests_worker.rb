class WithdrawalRequestsWorker
  include Sidekiq::Worker

  def perform(withdrawal_id)
  end
end
