require 'rails_helper'

describe GetFeeBalance do
  def perform
    described_class.for
  end

  let(:balance) { -145000 }
  let(:ledger_account) { create(:user_ledger_account, balance: balance) }

  before do
    allow(ENV).to receive(:fetch)
      .with('BUSINESS_USER_ID').and_return(ledger_account.accountable_id)
  end

  it 'returns expected balance' do
    expect(perform).to eq(145000)
  end
end
