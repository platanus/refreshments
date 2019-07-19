require 'rails_helper'

describe Ledger::RegisterInvoiceProduct do
  def perform
    described_class.new(invoice_product).perform
  end

  let(:node) { create(:wallet) }
  let(:price) { 5000 }
  let(:settled) { true }
  let(:invoice) { create(:invoice, settled: settled, amount: price) }
  let(:invoice_product) { create(:invoice_product, invoice: invoice) }
  let(:user) { invoice_product.user_product.user }

  before do
    ENV["PLATANUS_WALLET_ID"] = node.id.to_s
  end

  context "when a invoice is settled" do
    it { expect { perform }.to change { node.available_funds.balance }.from(0).to(price) }
    it { expect { perform }.to change { user.available_funds.balance }.from(0).to(-price) }
  end

  context "when a invoice isn't settled" do
    let(:settled) { false }

    it { expect { perform }.not_to change { node.available_funds.balance }.from(0) }
    it { expect { perform }.not_to change { user.available_funds.balance }.from(0) }
  end
end
