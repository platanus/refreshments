class GifUrl
  include ActiveModel::Serialization

  attr_accessor :gif_url

  def initialize(gif_url)
    @gif_url = gif_url
  end
end
