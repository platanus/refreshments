class WithdrawalObserver < PowerTypes::Observer
  after_save :register_withdrawal_payment

  def register_withdrawal_payment
    RegisterWithdrawalPaymentJob.set(wait: 5.seconds).perform_later(object)
  end
end
