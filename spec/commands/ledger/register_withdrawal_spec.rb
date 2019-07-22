require 'rails_helper'

describe Ledger::RegisterWithdrawal do
  def perform
    described_class.new(withdrawal).perform
  end

  let(:node) { create(:wallet) }
  let(:amount) { 10000 }
  let(:user) { create(:user) }
  let(:withdrawal) { create(:withdrawal, user: user, amount: amount, aasm_state: :confirmed) }

  before do
    ENV["PLATANUS_WALLET_ID"] = node.id.to_s
    allow(user).to receive(:withdrawable_amount).and_return(20000)
  end

  context "when a onchain withdrawal is confirmed" do
    it { expect { perform }.to change { node.available_funds.balance }.by(-amount) }
    it { expect { perform }.to change { user.available_funds.balance }.by(amount) }
  end
end
