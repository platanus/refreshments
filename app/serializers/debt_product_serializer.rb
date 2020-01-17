class DebtProductSerializer < ActiveModel::Serializer
  attributes :id, :debtor, :product_id, :product_price
end
