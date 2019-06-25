require 'rails_helper'

RSpec.describe GiphyClient do
  let(:success) { double(success?: true) }
  let(:failure) { double(success?: false) }
  let(:client) { described_class.new }
  let(:data) { { 'image_url' => 'a gif url' } }

  before do
    stub_const('GiphyClient::BASE_URL', 'stubbed_base_url')
    stub_const('GiphyClient::API_KEY', 'stubbed_api_key')
    stub_const('GiphyClient::GIF_SEARCH', 'stubbed_gif_search')
  end

  describe '#random_gif' do
    before do
      expect(GiphyClient).to receive(:get)
        .with('/random?&api_key=stubbed_api_key&tag=stubbed_gif_search')
        .and_return(response)
      allow(response).to receive(:[]).with('data').and_return(data)
    end

    context 'when node returns valid info' do
      let(:response) { success }

      it 'returns node response' do
        expect(client.random_gif.gif_url).to eq('a gif url')
      end
    end

    context 'when node returns error' do
      let(:response) { failure }

      it 'raises exception' do
        expect { client.random_gif }.to raise_error
      end
    end
  end
end
