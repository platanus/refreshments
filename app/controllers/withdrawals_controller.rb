class WithdrawalsController < ApplicationController
  before_action :authenticate_user!

  def new
    @withdrawal = current_user.withdrawals.new
  end

  def validate
    build_withdrawal
    validate_withdrawal
    return if performed?
    render 'confirm'
  end

  def create
    build_withdrawal
    validate_withdrawal
    return if performed?
    @withdrawal.save
    render 'create'
  end

  private

  def validate_withdrawal
    render 'new' unless @withdrawal.valid?
  end

  def build_withdrawal
    @withdrawal = current_user.withdrawals.new(withdrawal_params)
  end

  def withdrawal_params
    params.require(:withdrawal).permit(:amount, :btc_address)
  end
end
