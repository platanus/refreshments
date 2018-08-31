require 'rails_helper'

describe Api::V1::ProductsController, type: :controller do
  describe "GET #index" do
    before { create_list(:product, 10) }

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "returns products" do
      get :index
      expect(JSON.parse(response.body)["products"].size).to eq(10)
    end
  end
end
