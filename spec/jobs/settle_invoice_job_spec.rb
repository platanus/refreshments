require "rails_helper"

describe SettleInvoiceJob, type: :job do
  let(:r_hash) { "r_hash" }

  def perform
    SettleInvoiceJob.new.perform(r_hash)
  end

  def perform_later
    SettleInvoiceJob.perform_later(r_hash)
  end

  describe "#perform_later" do
    it "enqueues job" do
      expect { perform_later }.to have_enqueued_job
    end
  end

  context "with Invoice" do
    let(:invoice) { create(:invoice, r_hash: r_hash, settled: false) }

    it "settles invoice" do
      expect { perform }.to change { invoice.reload.settled }.from(false).to(true)
    end
  end

  context "without Invoice" do
    it "doesn't settle invoice" do
      expect_any_instance_of(Invoice).not_to receive(:update!)
    end
  end
end
