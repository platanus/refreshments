class Api::V1::GifsController < Api::V1::BaseController
  def show_random
    gif_url = giphy_client.random_gif
    respond_with gif_url: gif_url
  end

  private

  def giphy_client
    @giphy_client ||= GiphyClient.new
  end
end
