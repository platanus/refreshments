require 'rails_helper'

describe Api::V1::GifsController, type: :controller do
  describe 'GET #import_gif' do
    it 'returns http success' do
      get :import_gif
      expect(response).to have_http_status(:success)
    end
  end
end
