require 'rails_helper'

describe Ledger::RegisterLightningNetworkWithdrawalNew do
  def perform
    described_class.new(ln_withdrawal).perform
  end

  let(:amount) { 5000 }
  let(:user) { create(:user) }
  let(:ln_withdrawal) { create(:lightning_network_withdrawal, user: user, amount: amount) }

  context "when a lightning network withdrawal is created" do
    it { expect { perform }.to change { user.available_funds.balance }.by(amount) }
    it { expect { perform }.to change { user.unconfirmed_withdrawal_funds.balance }.by(-amount) }
  end
end
