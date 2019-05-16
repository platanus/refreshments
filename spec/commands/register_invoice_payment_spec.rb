require 'rails_helper'

describe RegisterInvoicePayment do
  def perform(*_args)
    described_class.for(*_args)
  end

  context "when a invoice is settled" do
    let(:platanus) { create(:wallet) }
    let(:user_with_invoice) { create(:user_with_invoice) }
    let(:invoice) { user_with_invoice.invoices.first }
    let(:lightning_account) do
      create(:ledger_account, accountable: platanus, category: 'Wallet')
    end
    let(:user_account) do
      create(:ledger_account, accountable: user_with_invoice, category: 'DebtToSellers')
    end

    def ledger_transfer_params(invoice_products)
      {
        from: user_account,
        to: lightning_account,
        countable: invoice_products,
        amount: invoice_products.product_price,
        date: invoice.created_at
      }
    end

    before do
      invoice.invoice_products.each do |invoice_products|
        expect(Ledger::Transfer).to receive(:for)
          .with(ledger_transfer_params(invoice_products))
      end
    end

    it do
      ENV["PLATANUS_WALLET_ID"] = platanus.id.to_s
      perform(invoice: invoice)
    end
  end

  context "when a invoice isn't settled" do
    let!(:invoice) { build(:invoice, settled: false) }

    it do
      expect(perform(invoice: invoice)).to eq(nil)
    end
  end
end
