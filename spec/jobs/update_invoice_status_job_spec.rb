require 'rails_helper'

RSpec.describe UpdateInvoiceStatusJob, type: :job do
  let(:invoice) { create(:invoice) }
  let(:r_hash) { 'r_hash' }

  def perform
    described_class.perform_now(invoice.r_hash)
  end

  def perform_later
    described_class.perform_later(invoice.r_hash)
  end

  describe "#perform_later" do
    it "enqueues job" do
      expect { perform_later }.to have_enqueued_job
    end
  end

  context "with invoice created" do
    before do
      allow(InvoiceUtils).to receive(:status).with(invoice.r_hash).and_return(invoice.settled)
      allow(SettleInvoiceJob).to receive(:perform_later).with(invoice.r_hash) if invoice.settled
      allow(DispenseProductsJob).to receive(:perform_later).with(invoice.r_hash) if invoice.settled
      allow(ActionCable.server).to receive(:broadcast).with('invoices', settled: invoice.settled)
    end

    it "returns settled status" do
      perform
    end
  end
end
