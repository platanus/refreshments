class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :amount, :clp, :payment_request, :r_hash, :memo, :settled
end
