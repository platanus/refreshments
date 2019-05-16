require 'rails_helper'

describe InvoiceObserver do
  def trigger(_type, _event)
    described_class.trigger(_type, _event, invoice)
  end

  let(:invoice) { build(:invoice) }

  before do
    allow(RegisterInvoicePayment).to receive(:for).with(invoice: invoice)
  end

  context "when invoice is save" do
    it do
      trigger(:after, :save)
      expect(RegisterInvoicePayment).to have_received(:for).with(invoice: invoice)
    end
  end

  context "when invoice is not save" do
    it do
      trigger(:before, :save)
      expect(RegisterInvoicePayment).to_not have_received(:for)
    end
  end
end
