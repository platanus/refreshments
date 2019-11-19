require "rails_helper"

describe DispenseProductsJob, type: :job do
  let(:r_hash) { 'r_hash' }

  def perform
    described_class.perform_now(r_hash)
  end

  context 'when invoice is not found' do
    it 'raises error' do
      expect { perform }.to raise_error(ActiveRecord::RecordNotFound, "Couldn't find Invoice")
    end
  end

  context 'when invoice is found' do
    let(:invoice) { create(:invoice, r_hash: r_hash, settled: true) }
    let(:product) { create(:product, webhook_url: 'www.grifosnuts.com/dispense') }
    let(:invoice_product) do
      create(:invoice_product, invoice: invoice, dispensed: false, product: product)
    end

    before do
      allow(DispenseProduct).to receive(:for).with(invoice_product: invoice_product)
    end

    it 'calls DispenseProduct command' do
      perform
      expect(DispenseProduct).to have_received(:for).with(invoice_product: invoice_product)
    end
  end
end
