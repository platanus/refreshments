class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :image_url, :user_products

  has_many :user_products

  def user_products
    @object.user_products.for_sale
  end

  def image_url
    if object.image.variable?
      rails_representation_url(object.image.variant(resize: "500x500"), only_path: true)
    else
      rails_blob_path(object.image, only_path: true)
    end
  end
end
