require 'rails_helper'

RSpec.describe Api::V1::InvoicesController, type: :controller do
  describe 'POST #create' do
    let(:products_hash) do
      {
        123 => { 'amount' => 3 },
        234 => { 'amount' => 2 }
      }
    end
    let(:invoice_params) do
      { invoice: { products: products_hash } }
    end
    let!(:product_1) { create(:product, id: 123) }
    let!(:product_2) { create(:product, id: 234) }

    before do
      expect(CreateInvoice).to receive(:for)
    end

    it 'returns http success' do
      post :create, params: invoice_params, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'shopping_cart_items have correct values' do
      post :create, params: invoice_params, as: :json
      expect(assigns(:shopping_cart_items).first).to have_attributes(
        product: product_1,
        amount: 3
      )
      expect(assigns(:shopping_cart_items).last).to have_attributes(
        product: product_2,
        amount: 2
      )
    end
  end

  describe 'GET #status' do
    let(:invoice) { create(:invoice, r_hash: 'r_hash') }

    it 'returns http success' do
      get :status, params: { r_hash: invoice.r_hash }, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns settled' do
      get :status, params: { r_hash: invoice.r_hash }, as: :json
      expect(JSON.parse(response.body)).to eq('settled' => true)
    end
  end
end
