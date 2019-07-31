require 'rails_helper'

describe Ledger::RegisterInvoiceProductFee do
  def perform
    described_class.new(invoice_product).perform
  end

  let(:business_user) { create(:user) }
  let(:price) { 5000 }
  let(:settled) { true }
  let(:fee_rate) { 0.01 }
  let(:invoice) { create(:invoice, settled: settled, amount: price) }
  let(:invoice_product) { create(:invoice_product, invoice: invoice, fee_rate: fee_rate) }
  let(:user) { invoice_product.user_product.user }

  before do
    ENV["BUSINESS_USER_ID"] = business_user.id.to_s
  end

  context "when an invoice is settled" do
    it 'changes the user available funds by the product fee' do
      expect { perform }.to(
        change { user.available_funds.balance }.from(0).to(invoice_product.product_fee)
      )
    end
    it 'changes the business user available funds by the product fee' do
      expect { perform }.to(
        change { business_user.available_funds.balance }.from(0).to(-invoice_product.product_fee)
      )
    end
  end

  context "when an invoice isn't settled" do
    let(:settled) { false }

    it { expect { perform }.not_to change { user.available_funds.balance }.from(0) }
    it { expect { perform }.not_to change { business_user.available_funds.balance }.from(0) }
  end
end
