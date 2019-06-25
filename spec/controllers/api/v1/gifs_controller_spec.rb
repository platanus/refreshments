require 'rails_helper'

describe Api::V1::GifsController, type: :controller do
  let(:gif_url) { GifUrl.new('a gif url') }
  describe 'GET #show_random' do
    before do
      allow_any_instance_of(GiphyClient).to receive(:random_gif).and_return(gif_url)
    end
    it 'returns http success' do
      get :show_random, as: :json
      expect(response).to have_http_status(:success)
    end
  end
end
