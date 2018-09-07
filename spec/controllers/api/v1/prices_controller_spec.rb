require 'rails_helper'

RSpec.describe Api::V1::PricesController, type: :controller do
  describe "GET #satoshi_price" do
    context "with clp_price" do
      before do
        allow(GetPriceOnSatoshis).to receive(:for).with(clp_price: 650).and_return(10000)
      end

      it "returns http success" do
        get :satoshi_price, params: { clp_price: 650 }, as: :json
        expect(response).to have_http_status(:success)
      end

      it "returns http success" do
        get :satoshi_price, params: { clp_price: 650 }, as: :json
        expect(JSON.parse(response.body)).to eq("satoshi_price" => 10_000)
      end
    end

    context "without clp_price" do
      it "returns http success" do
        get :satoshi_price, as: :json
        expect(response).to have_http_status(:success)
      end

      it "returns http success" do
        get :satoshi_price, as: :json
        expect(JSON.parse(response.body)).to eq("error" => "No clp_price given")
      end
    end
  end
end
