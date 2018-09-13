require 'rails_helper'

RSpec.describe Api::V1::InvoicesController, type: :controller do
  describe "POST #create" do
    let(:product_a) { create(:product, name: "Coca Cola", price: 500) }
    let(:product_b) { create(:product, name: "Sprite", price: 650) }

    let!(:product_a_id) { product_a.id }
    let!(:product_b_id) { product_b.id }

    let(:invoice_params) do
      {
        invoice: {
          memo: "Guillermo Moreno",
          products: { product_a_id => 1, product_b_id => 1 }
        }
      }
    end

    before { allow(CreateInvoice).to receive(:for) }

    it "returns http success" do
      post :create, params: invoice_params, as: :json
      expect(response).to have_http_status(:success)
    end

    fit "calls CreateInvoice" do
      expect(CreateInvoice).to receive(:for).with(
        memo: "Guillermo Moreno", products_hash: { product_a_id.to_s => 1, product_b_id.to_s => 1 }
      )
      post :create, params: invoice_params, as: :json
    end
  end

  describe "GET #status" do
    before { allow(InvoiceUtils).to receive(:status).with("r_hash").and_return(true) }

    it "returns http success" do
      get :status, params: { r_hash: "r_hash" }, as: :json
      expect(response).to have_http_status(:success)
    end

    it "returns http success" do
      get :status, params: { r_hash: "r_hash" }, as: :json
      expect(JSON.parse(response.body)).to eq("settled" => true)
    end
  end
end
