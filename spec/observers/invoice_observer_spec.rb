require 'rails_helper'

describe InvoiceObserver do
  def trigger(_type, _event)
    described_class.trigger(_type, _event, invoice)
  end

  let(:invoice) { create(:invoice) }
  let(:invoice_product) { create(:invoice_product, invoice: invoice) }

  context 'when invoice is save' do
    it do
      trigger(:after, :save)
      expect { Ledger::RegisterInvoiceProductJob.to receive(:perform_later).with(invoice_product) }
    end
  end
end
