require 'rails_helper'

describe RegisterLightningNetworkWithdrawalPayment do
  def perform
    described_class.for(lightning_withdrawal: lightning_withdrawal)
  end

  before do
    PowerTypes::Observable.observable_disabled = true
  end

  after do
    if PowerTypes::Observable.observable_disabled?
      PowerTypes::Observable.observable_disabled = false
    end
  end

  let!(:platanus) { create(:wallet, id: 1) }

  context 'when a withdrawal is confirmed' do
    let(:user_with_invoice) { create(:user_with_invoice) }
    let(:lightning_account) do
      create(:ledger_account, accountable: platanus, category: 'Wallet')
    end
    let(:user_account) do
      create(:ledger_account, accountable: user_with_invoice, category: 'DebtToSellers')
    end
    let(:lightning_withdrawal) do
      build(
        :lightning_network_withdrawal,
        user_id: user_with_invoice.id,
        state: 'confirmed'
      )
    end

    let(:ledger_transfer_params) do
      {
        from: lightning_account,
        to: user_account,
        countable: lightning_withdrawal,
        amount: lightning_withdrawal.amount,
        date: lightning_withdrawal.created_at
      }
    end

    before do
      expect(Ledger::Transfer).to receive(:for)
        .with(ledger_transfer_params)
    end

    it do
      perform
    end
  end

  context 'when a withdrawal is rejected' do
    let!(:lightning_withdrawal) { build(:lightning_network_withdrawal, state: 'rejected') }

    it do
      expect(perform).to eq(nil)
    end
  end

  context 'when a withdrawal is allready accounted' do
    let(:lightning_withdrawal) { create(:lightning_network_withdrawal, state: 'confirmed') }

    before do
      perform
    end

    def accounted_lines_count
      LedgerLine.where(accountable: lightning_withdrawal).count
    end

    it 'should not add new ledger lines' do
      expect(accounted_lines_count).to eq(2)
      expect { perform }.to_not (change { accounted_lines_count })
    end
  end
end
