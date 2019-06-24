require 'rails_helper'

describe ProcessLightningNetworkWithdrawal do
  def perform(*_args)
    described_class.for(*_args)
  end

  let(:user) { create(:user) }
  let(:ledger_account) { create(:ledger_account, accountable: user) }
  let(:lightning_withdrawal) { create(:lightning_network_withdrawal, user_id: user.id) }
  let(:decode_response_body) do
    {
      'num_satoshis' => '10000',
      'description' => 'withdrawal memo'
    }
  end

  before do
    allow_any_instance_of(LightningNetworkClient).to receive(:decode_payment_request)
      .with(lightning_withdrawal.invoice_hash)
      .and_return(decode_response_body)
    allow_any_instance_of(LightningNetworkClient).to receive(:transaction)
      .with(lightning_withdrawal.invoice_hash)
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
      expect(RegisterLightningNetworkWithdrawalPayment).to receive(:for)
        .with(lightning_withdrawal: lightning_withdrawal)
        .and_return('success')
    end
    it 'memo and amount are correctly saved' do
      perform(lightning_withdrawal: lightning_withdrawal)
      expect { lightning_withdrawal.amount.to eq(10000) }
      expect { lightning_withdrawal.memo.to eq('withdrawal memo') }
    end

    it 'lightning withdrawal is confirmed' do
      perform(lightning_withdrawal: lightning_withdrawal)
      expect(lightning_withdrawal.state).to eq('confirmed')
    end

    it 'lightning withdrawal is registered in ledger' do
      perform(lightning_withdrawal: lightning_withdrawal)
    end
  end
end
