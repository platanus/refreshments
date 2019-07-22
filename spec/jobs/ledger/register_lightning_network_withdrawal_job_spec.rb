require 'rails_helper'

RSpec.describe Ledger::RegisterLightningNetworkWithdrawalJob, type: :job do
  let(:ln_withdrawal) { create(:lightning_network_withdrawal) }
  let(:ledger_register) { double("register", perform: {}) }

  def perform
    described_class.perform_now(ln_withdrawal)
  end

  it 'calls ledger RegisterLightningNetworkWithdrawal command with ln_withdrawal param' do
    expect(Ledger::RegisterLightningNetworkWithdrawalNew).to receive(:new)
      .with(ln_withdrawal)
      .and_return(ledger_register)

    expect(Ledger::RegisterLightningNetworkWithdrawalConfirmed).to receive(:new)
      .with(ln_withdrawal)
      .and_return(ledger_register)

    expect(Ledger::RegisterLightningNetworkWithdrawalFailed).to receive(:new)
      .with(ln_withdrawal)
      .and_return(ledger_register)

    perform
  end
end
