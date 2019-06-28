require 'rails_helper'

describe InvoiceObserver do
  def trigger(_type, _event)
    described_class.trigger(_type, _event, invoice)
  end

  let(:invoice) { create(:invoice) }

  context 'when invoice is save' do
    it do
      trigger(:after, :save)
      expect { RegisterInvoicePaymentJob.to receive(:perform_later).with(invoice) }
    end
  end

  context 'when invoice is not save' do
    it do
      trigger(:before, :save)
      expect { RegisterInvoicePaymentJob.to_not receive(:perform_later) }
    end
  end
end
