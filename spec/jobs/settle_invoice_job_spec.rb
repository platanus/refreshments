require "rails_helper"

describe SettleInvoiceJob, type: :job do
  let(:r_hash) { "r_hash" }

  def perform
    SettleInvoiceJob.new.perform(r_hash)
  end

  def perform_later
    SettleInvoiceJob.perform_later(r_hash)
  end

  before { allow_any_instance_of(DoorClient).to receive(:open_door) }

  describe "#perform_later" do
    it "enqueues job" do
      expect { perform_later }.to have_enqueued_job
    end
  end

  context "with Invoice" do
    let(:invoice) { create(:invoice, r_hash: r_hash, settled: false) }
    let(:invoice_product_a) { create(:invoice_product, invoice: invoice) }

    it "settles invoice & opens door" do
      expect_any_instance_of(DoorClient).to receive(:open_door)
      expect { perform }.to change { invoice.reload.settled }.from(false).to(true)
    end

    it 'reduces stock of invoice products' do
      expect { perform }.to change { invoice_product_a.user_product.reload.stock }.by(-1)
    end
  end

  context "with settled Invoice" do
    let(:invoice) { create(:invoice, r_hash: r_hash, settled: true) }

    it "doesn't settle invoice & doesn't open door" do
      expect_any_instance_of(Invoice).not_to receive(:update!)
      expect_any_instance_of(DoorClient).not_to receive(:open_door)
      perform
    end
  end

  context "without Invoice" do
    it "doesn't settle invoice & doesn't open door" do
      expect_any_instance_of(Invoice).not_to receive(:update!)
      expect_any_instance_of(DoorClient).not_to receive(:open_door)
      perform
    end
  end
end
