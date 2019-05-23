require 'rails_helper'

describe RegisterWithdrawalPayment do
  def perform(*_args)
    described_class.for(*_args)
  end

  context "when a withdrawal is confirmed" do
    let(:platanus) { create(:wallet) }
    let(:user_with_invoice) { create(:user_with_invoice) }
    let(:lightning_account) do
      create(:ledger_account, accountable: platanus, category: 'Wallet')
    end
    let(:user_account) do
      create(:ledger_account, accountable: user_with_invoice, category: 'DebtToSellers')
    end
    let(:withdrawal) { build(:withdrawal, user: user_with_invoice, aasm_state: 'confirmed') }

    let(:ledger_transfer_params) do
      {
        from: lightning_account,
        to: user_account,
        countable: withdrawal,
        amount: withdrawal.amount,
        date: withdrawal.created_at
      }
    end

    before do
      allow(withdrawal).to receive(:add_job_to_withdrawal_requests_worker).and_return(true)
      expect(Ledger::Transfer).to receive(:for)
        .with(ledger_transfer_params)
    end

    it do
      ENV["PLATANUS_WALLET_ID"] = platanus.id.to_s
      perform(withdrawal: withdrawal)
    end
  end

  context "when a withdrawal is rejected" do
    let!(:withdrawal) { build(:withdrawal, aasm_state: 'rejected') }

    it do
      expect(perform(withdrawal: withdrawal)).to eq(nil)
    end
  end
end
