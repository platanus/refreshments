require 'rails_helper'

describe DispenseProduct do
  def perform(*_args)
    described_class.for(*_args)
  end

  let(:product) { create(:product, webhook_url: 'www.grifosnuts.com/dispense') }
  let(:invoice_product) { create(:invoice_product, dispensed: dispensed, product: product) }

  context 'when invoice product was already dispensed' do
    let(:dispensed) { true }

    it 'raises error' do
      expect { perform(invoice_product: invoice_product) }.to raise_error(
        StandardError, "Invoice Product #{invoice_product.id} was already dispensed"
      )
    end
  end

  context 'when the product has not been dispensed' do
    let(:dispensed) { false }
    let(:response) { double }

    before do
      allow(HTTParty).to receive(:get).with(
        'www.grifosnuts.com/dispense', headers: { 'X-Refreshments-Event' => 'dispense' }
      ).and_return(response)
      allow(response).to receive(:code).and_return(code)
    end

    context 'when the service is available' do
      let(:code) { 200 }

      before do
        perform(invoice_product: invoice_product)
      end

      it 'performs get request to external service' do
        expect(HTTParty).to have_received(:get).with(
          'www.grifosnuts.com/dispense', headers: { 'X-Refreshments-Event' => 'dispense' }
        )
      end

      it "sets dispensed value as 'true'" do
        expect(invoice_product.dispensed).to eq(true)
      end
    end

    context 'when the service is unavailable' do
      let(:code) { 500 }

      it 'raises error' do
        expect { perform(invoice_product: invoice_product) }.to raise_error(
          StandardError, "Unable to dispense Invoice Product #{invoice_product.id}"
        )
      end
    end
  end
end
