require 'rails_helper'

describe InvoiceObserver do
  def trigger(_type, _event)
    described_class.trigger(_type, _event, invoice)
  end

  let(:invoice) { create(:invoice) }

  context 'when invoice is save' do
    it do
      trigger(:after, :save)
      expect { RegisterInvoicePaymentJob.to have_enqueued_job.with(invoice.id) }
    end
  end

  context 'when invoice is not save' do
    it do
      trigger(:before, :save)
      expect { RegisterInvoicePaymentJob.to_not have_enqueued_job }
    end
  end
end
