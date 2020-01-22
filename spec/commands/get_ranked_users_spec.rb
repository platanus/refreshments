require 'rails_helper'

describe GetRankedUsers do
  let(:ledger_one) { create(:user_ledger_account, :with_fee_line) }
  let(:ledger_two) { create(:user_ledger_account, :with_fee_line,  :with_fee_line) }
  let(:user_array) { [ledger_one.accountable, ledger_two.accountable] }

  def perform
    described_class.for(rankable_users: user_array)
  end

  it 'returns correctly ordered array' do
    expect(perform).to match_array([ledger_two.accountable, ledger_one.accountable])
  end
end
