require 'rails_helper'

RSpec.describe RegisterLightningNetworkWithdrawalPaymentJob, type: :job do
  ActiveJob::Base.queue_adapter = :test

  before do
    PowerTypes::Observable.observable_disabled = true
  end

  let(:lightning_network_withdrawal) { create(:lightning_network_withdrawal) }

  describe '#perform_later' do
    it do
      expect do
        RegisterLightningNetworkWithdrawalPaymentJob.perform_later(lightning_network_withdrawal)
      end.to have_enqueued_job.on_queue('ledger_transaction')
    end
  end

  describe '#perform_now' do
    before do
      allow(RegisterLightningNetworkWithdrawalPayment).to receive(:for)
        .with(lightning_withdrawal: lightning_network_withdrawal)
    end

    it do
      RegisterLightningNetworkWithdrawalPaymentJob.perform_now(lightning_network_withdrawal)
      expect(RegisterLightningNetworkWithdrawalPayment).to have_received(:for)
        .with(lightning_withdrawal: lightning_network_withdrawal)
    end
  end
end
