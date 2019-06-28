class RegisterLightningNetworkWithdrawalPaymentJob < ApplicationJob
  queue_as :ledger_transaction

  def perform(lightning_withdrawal)
    RegisterLightningNetworkWithdrawalPayment.for(lightning_withdrawal: lightning_withdrawal)
  end
end
