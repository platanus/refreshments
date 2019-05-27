require 'rails_helper'

RSpec.describe RegisterInvoicePaymentJob, type: :job do
  ActiveJob::Base.queue_adapter = :test

  before do
    PowerTypes::Observable.observable_disabled = true
  end

  let(:invoice) { create(:invoice) }

  describe "#perform_later" do
    it do
      expect do
        RegisterInvoicePaymentJob.perform_later(invoice)
      end.to have_enqueued_job.on_queue("ledger_transaction")
    end
  end

  describe "#perform_now" do
    before do
      allow(RegisterInvoicePayment).to receive(:for).with(invoice: invoice)
    end

    it do
      RegisterInvoicePaymentJob.perform_now(invoice)
      expect(RegisterInvoicePayment).to have_received(:for).with(invoice: invoice)
    end
  end
end
