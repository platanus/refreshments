require 'rails_helper'

describe Api::V1::ProductsController, type: :controller do
  describe "GET #index" do
    let(:user) { create(:user) }
    let!(:product) { create(:product, active: false, user: user) }
    before { create_list(:product, 10, user: user) }

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "returns active products" do
      get :index
      expect(Product.all.length).to eq(11)
      expect(JSON.parse(response.body)["products"].size).to eq(10)
    end
  end
end
