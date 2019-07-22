require 'rails_helper'

describe Ledger::RegisterLightningNetworkWithdrawalFailed do
  def perform
    described_class.new(ln_withdrawal).perform
  end

  let(:node) { create(:wallet) }
  let(:amount) { 5000 }
  let(:user) { create(:user) }
  let(:ln_withdrawal) { create(:lightning_network_withdrawal, user: user, amount: amount) }

  before do
    ENV["PLATANUS_WALLET_ID"] = node.id.to_s
  end

  context "when a lightning network withdrawal failed" do
    before do
      ln_withdrawal.state = :failed
    end

    it { expect { perform }.to change { user.available_funds.balance }.by(-amount) }
    it { expect { perform }.to change { user.unconfirmed_withdrawal_funds.balance }.by(amount) }
  end

  context "when a lightning network withdrawal was rejected" do
    before do
      ln_withdrawal.state = :rejected
    end

    it { expect { perform }.to change { user.available_funds.balance }.by(-amount) }
    it { expect { perform }.to change { user.unconfirmed_withdrawal_funds.balance }.by(amount) }
  end
end
