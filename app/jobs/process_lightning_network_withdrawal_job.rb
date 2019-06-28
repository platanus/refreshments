class ProcessLightningNetworkWithdrawalJob < ApplicationJob
  queue_as :ledger_transaction

  def perform(lightning_withdrawal)
    ProcessLightningNetworkWithdrawal.for(lightning_withdrawal: lightning_withdrawal)
  end
end
