class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :price, :image_url

  def image_url
    rails_blob_path(object.image, only_path: true)
  end
end
