require 'rails_helper'

describe Ledger::Transfer do
  def perform(*_args)
    described_class.for(*_args)
  end

  let(:amount_traded) { 50 }
  let(:initial_balance) { 100 }
  let(:account_from) { build(:ledger_account, balance: initial_balance) }
  let(:account_to) { build(:ledger_account, balance: initial_balance) }
  let(:invoice_product) { build(:invoice_product) }

  before do
    perform(
      from: account_from,
      to: account_to,
      amount: amount_traded,
      accountable: invoice_product,
      date: invoice_product.created_at,
      category: 'new'
    )
  end

  it "creates ledger line for account_from" do
    expect(
      LedgerLine.where(
        ledger_account: account_from,
        amount: -amount_traded
      ).count
    ).to eq(1)
  end

  it "creates ledger line for account_to" do
    expect(
      LedgerLine.where(
        ledger_account: account_to,
        amount: amount_traded
      ).count
    ).to eq(1)
  end

  it "decrease account_from balance" do
    expect(account_from.balance).to eq(initial_balance - amount_traded)
  end

  it "increases account_to balance " do
    expect(account_to.balance).to eq(initial_balance + amount_traded)
  end
end
