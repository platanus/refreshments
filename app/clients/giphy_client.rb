class GiphyClient
  include HTTParty
  BASE_URL = 'https://api.giphy.com/v1/gifs'
  API_KEY = ENV['GIPHY_API_KEY']
  GIF_SEARCH = 'celebration'.freeze

  base_uri BASE_URL

  def random_gif
    response = check_success self.class.get("/random?&api_key=#{API_KEY}&tag=#{GIF_SEARCH}")
    gif_url = response['data']['image_url']
    GifUrl.new(gif_url)
  end

  private

  def check_success(response)
    raise GiphyClientError::ClientError, response unless response.success?

    response
  end
end
