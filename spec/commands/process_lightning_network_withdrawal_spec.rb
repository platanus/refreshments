require 'rails_helper'

describe ProcessLightningNetworkWithdrawal do
  def perform(*_args)
    described_class.for(*_args)
  end

  let(:user) { create(:user) }
  let(:user_available_funds) { 5000 }
  let(:lightning_withdrawal) { create(:lightning_network_withdrawal, user: user) }
  let(:payment_response) do
    {
      'payment_route' => payment_route
    }
  end

  before do
    allow(user).to receive(:withdrawable_amount).and_return(user_available_funds)
  end

  context 'without enough funds' do
    let(:user_available_funds) { 1000 }

    it 'lightning withdrawal is rejected' do
      perform(lightning_withdrawal: lightning_withdrawal)
      expect(lightning_withdrawal.state).to eq('rejected')
    end
  end

  context 'with enough funds' do
    let(:user_available_funds) { 10000 }

    before do
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
