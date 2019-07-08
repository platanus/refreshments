require 'rails_helper'

describe ProcessLightningNetworkWithdrawal do
  def perform(*_args)
    described_class.for(*_args)
  end

  let(:user) { create(:user) }
  let(:ledger_account) { create(:ledger_account, accountable: user) }
  let(:lightning_withdrawal) { create(:lightning_network_withdrawal, user_id: user.id) }
  let(:payment_response) do
    {
      'payment_route' => payment_route
    }
  end

  context 'without enough funds' do
    before { create(:ledger_line, ledger_account: ledger_account, balance: -5000) }
    it 'lightning withdrawal is rejected' do
      perform(lightning_withdrawal: lightning_withdrawal)
      expect(lightning_withdrawal.state).to eq('rejected')
    end
  end

  context 'with enough funds' do
    before do
      create(:ledger_line, ledger_account: ledger_account, balance: -10000)
      allow_any_instance_of(LightningNetworkClient).to receive(:transaction)
        .with(lightning_withdrawal.invoice_hash)
        .and_return(payment_response)
    end

    context 'when transaction is successful' do
      let(:payment_route) { 'some route' }
      it 'lightning withdrawal is confirmed' do
        perform(lightning_withdrawal: lightning_withdrawal)
        expect(lightning_withdrawal.state).to eq('confirmed')
      end
    end

    context 'when transaction is unsuccessful' do
      let(:payment_route) { nil }
      it 'lightning withdrawal is failed' do
        perform(lightning_withdrawal: lightning_withdrawal)
        expect(lightning_withdrawal.state).to eq('failed')
      end
    end
  end
end
