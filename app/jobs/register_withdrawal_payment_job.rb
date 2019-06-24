class RegisterWithdrawalPaymentJob < ApplicationJob
  queue_as :ledger_transaction

  def perform(withdrawal)
    RegisterWithdrawalPayment.for(withdrawal: withdrawal)
  end
end
