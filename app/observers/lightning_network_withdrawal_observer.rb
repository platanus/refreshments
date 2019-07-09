class LightningNetworkWithdrawalObserver < PowerTypes::Observer
  after_create :process_lightning_network_withdrawal
  after_save :register_lightning_network_withdrawal_payment

  def process_lightning_network_withdrawal
    ProcessLightningNetworkWithdrawalJob.set(wait: 5.seconds).perform_later(object)
  end

  def register_lightning_network_withdrawal_payment
    RegisterLightningNetworkWithdrawalPaymentJob.set(wait: 5.seconds).perform_later(object)
  end
end
