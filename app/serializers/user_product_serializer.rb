class UserProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :stock, :price, :image_url, :for_sale, :category

  def for_sale
    object.active && object.stock.positive?
  end

  def image_url
    if object.image.variable?
      rails_representation_url(object.image.variant(resize: "500x500"), only_path: true)
    else
      rails_blob_path(object.image, only_path: true)
    end
  end
end
