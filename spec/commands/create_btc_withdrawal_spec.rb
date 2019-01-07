require 'rails_helper'

RSpec.describe CreateBTCWithdrawal, type: :command do
  def mock_buda_client
    @buda_client = instance_double(BudaClient)
    allow(@buda_client).to receive(:generate_withdrawal)
    @buda_client
  end

  def initialize_withdrawal
    @withdrawal = instance_double(Withdrawal)
    allow(@withdrawal).to receive(:btc_amount).and_return(10)
    allow(@withdrawal).to receive(:btc_address).and_return('some address')
  end

  def initialize_context
    allow_any_instance_of(CreateBTCWithdrawal)
      .to receive(:buda_client).and_return(mock_buda_client)
    initialize_withdrawal
  end

  describe 'CreateBTCWithdrawal' do
    before do
      initialize_context
      CreateBTCWithdrawal.for(withdrawal: @withdrawal)
    end

    it 'calls perform method with correct params' do
      expect(@buda_client).to have_received(:generate_withdrawal)
        .with(10, 'some address')
    end
  end
end
