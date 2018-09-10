class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :satoshis, :clp, :payment_request, :r_hash, :memo
end
