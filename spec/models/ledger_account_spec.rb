require 'rails_helper'

RSpec.describe LedgerAccount, type: :model do
  it "has a valid factory" do
    account = build(:ledger_account)
    expect(account).to be_valid
  end
end
