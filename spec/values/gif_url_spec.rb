require 'rails_helper'

RSpec.describe GifUrl, type: :value do
  let(:url) { 'a gif url' }
  let(:gif_url) { described_class.new(url) }

  describe 'initialize' do
    it { expect(gif_url.gif_url).to eq(url) }
  end
end
