class WithdrawalObserver < PowerTypes::Observer
  after_save :register_withdrawal_payment

  def register_withdrawal_payment
    RegisterWithdrawalPayment.for(withdrawal: object)
  end
end
