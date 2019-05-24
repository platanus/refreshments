require 'rails_helper'

describe Api::V1::ProductsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user_with_product, product_count: 10) }
    before { create(:user_product, user: user, active: false) }

    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns active products' do
      get :index
      expect(Product.all.length).to eq(11)
      expect(JSON.parse(response.body)['products'].size).to eq(11)
    end
  end
end
