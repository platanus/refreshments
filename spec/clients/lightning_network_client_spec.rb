require 'rails_helper'

RSpec.describe LightningNetworkClient do
  let(:success) { double(success?: true) }
  let(:failure) { double(success?: false) }

  let(:client) { described_class.new }

  describe '#invoices' do
    before do
      expect(LightningNetworkClient).to receive(:get)
        .with('/invoices', anything)
        .and_return(response)
    end

    context 'when node returns valid info' do
      let(:response) { success }

      it 'returns node response' do
        expect(client.invoices).to eq(response)
      end
    end

    context 'when node returns error' do
      let(:response) { failure }

      it 'raises exception' do
        expect { client.invoices }.to raise_error
      end
    end
  end

  describe '#invoice' do
    let(:rhash) { 'expected_rhash' }

    before do
      expect(LightningNetworkClient).to receive(:get)
        .with("/invoice/#{rhash}", anything)
        .and_return(response)
    end

    context 'when node returns valid info' do
      let(:response) { success }

      it 'returns node response' do
        expect(client.invoice(rhash)).to eq(response)
      end
    end

    context 'when node returns error' do
      let(:response) { failure }

      it 'raises exception' do
        expect { client.invoice(rhash) }.to raise_error
      end
    end
  end

  describe '#create_invoice' do
    before do
      expect(LightningNetworkClient).to receive(:post)
        .with("/invoices", anything)
        .and_return(response)
    end

    context 'when node returns valid info' do
      let(:response) { success }

      it 'returns node response' do
        expect(client.create_invoice('memo', 0.1234)).to eq(response)
      end
    end

    context 'when node returns error' do
      let(:response) { failure }

      it 'raises exception' do
        expect { client.create_invoice('memo', 0.1234) }.to raise_error
      end
    end
  end
end
