class Ledger::RegisterLightningNetworkWithdrawalJob < ApplicationJob
  queue_as :ledger_transaction

  def perform(ln_withdrawal)
    Ledger::RegisterLightningNetworkWithdrawalNew.new(ln_withdrawal).perform
    Ledger::RegisterLightningNetworkWithdrawalConfirmed.new(ln_withdrawal).perform
    Ledger::RegisterLightningNetworkWithdrawalFailed.new(ln_withdrawal).perform
  end
end
