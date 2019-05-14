require 'rails_helper'

RSpec.describe LedgerLine, type: :model do
  it "has a valid factory" do
    line = build(:ledger_line)
    expect(line).to be_valid
  end
end
