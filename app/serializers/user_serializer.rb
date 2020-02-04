class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :slack_user
end
