require 'rails_helper'

RSpec.describe Api::V1::InvoicesController, type: :controller do
  describe 'POST #create' do
    let(:products_hash) do
      {
        '1' => { 'amount' => 3, 'price' => 1000 },
        '2' => { 'amount' => 2, 'price' => 1000 }
      }
    end

    let(:invoice_params) do
      {
        invoice: {
          memo: 'Guillermo Moreno',
          products: products_hash
        }
      }
    end

    before { allow(CreateInvoice).to receive(:for) }

    it 'returns http success' do
      post :create, params: invoice_params, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'calls CreateInvoice' do
      post :create, params: invoice_params, as: :json
      expect(CreateInvoice).to have_received(:for).with(
        memo: 'Guillermo Moreno', products_hash: products_hash
      )
    end
  end

  describe 'GET #status' do
    let(:r_hash) { 'r_hash' }

    before do
      allow(InvoiceUtils).to receive(:status).with(r_hash).and_return(true)
      allow(SettleInvoiceJob).to receive(:perform_later).with(r_hash)
    end

    it 'returns http success' do
      get :status, params: { r_hash: 'r_hash' }, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns settled' do
      get :status, params: { r_hash: 'r_hash' }, as: :json
      expect(JSON.parse(response.body)).to eq('settled' => true)
    end

    it 'calls SettleInvoiceJob' do
      get :status, params: { r_hash: 'r_hash' }, as: :json
      expect(SettleInvoiceJob).to have_received(:perform_later).with(r_hash)
    end
  end
end
