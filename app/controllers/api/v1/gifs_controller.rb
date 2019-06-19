class Api::V1::GifsController < Api::V1::BaseController
  API_KEY = ENV['GIPHY_API_KEY']
  GIF_SEARCH = 'celebration'.freeze

  def import_gif
    url = format(
      'https://api.giphy.com/v1/gifs/random?&api_key=%<api_key>s&tag=%<gif_search>s',
      api_key: API_KEY,
      gif_search: GIF_SEARCH
    )
    response = HTTParty.get(url)
    render json: response
  end
end
