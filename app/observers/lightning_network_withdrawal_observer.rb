class LightningNetworkWithdrawalObserver < PowerTypes::Observer
  after_create :process_lightning_network_withdrawal

  def process_lightning_network_withdrawal
    ProcessLightningNetworkWithdrawalJob.set(wait: 5.seconds).perform_later(object)
  end
end
