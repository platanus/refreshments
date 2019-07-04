class LightningNetworkWithdrawalsController < ApplicationController
  before_action :authenticate_user!

  def new
    @lightning_network_withdrawal = LightningNetworkWithdrawal.new
  end

  def create
    PayInvoiceToUser.for(
      invoice_hash: lightning_network_withdrawal_params[:invoice_hash],
      user: current_user
    )
    render 'successful'
  rescue LightningNetworkClientError::ClientError
    render 'unsuccessful'
  end

  private

  def lightning_network_withdrawal_params
    params.require(:lightning_network_withdrawal).permit(:invoice_hash)
  end
end
