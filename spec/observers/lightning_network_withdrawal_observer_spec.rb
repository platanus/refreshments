require 'rails_helper'

describe LightningNetworkWithdrawalObserver do
  def trigger(_type, _event)
    described_class.trigger(_type, _event, lightning_network_withdrawal)
  end

  let(:lightning_network_withdrawal) { create(:lightning_network_withdrawal) }

  context 'when lightning network is created' do
    it do
      trigger(:after, :create)
      expect do
        ProcessLightningNetworkWithdrawalJob.to receive(:perform_later)
          .with(lightning_network_withdrawal)
      end
    end
  end

  context 'when lightning network is not created' do
    it do
      trigger(:before, :create)
      expect { ProcessLightningNetworkWithdrawalJob.to_not receive(:perform_later) }
    end
  end

  context 'when lightning withdrawal is saved' do
    it do
      trigger(:after, :save)
      expect do
        Ledger::RegisterLightningNetworkWithdrawalJob.to receive(:perform_later)
          .with(lightning_network_withdrawal)
      end
    end
  end

  context 'when lightning network is not saved' do
    it do
      trigger(:before, :save)
      expect { Ledger::RegisterLightningNetworkWithdrawalJob.to_not receive(:perform_later) }
    end
  end
end
