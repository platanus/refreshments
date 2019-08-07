class GetFeeBalance < PowerTypes::Command.new
  def perform
    fee_balance
  end

  private

  def fee_balance
    -business_user.available_funds.balance
  end

  def business_user
    User.find(ENV.fetch("BUSINESS_USER_ID"))
  end
end
