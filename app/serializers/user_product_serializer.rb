class UserProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :stock, :price
end
