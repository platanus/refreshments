class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :amount, :fee_amount, :clp, :payment_request, :r_hash, :memo, :settled

  def fee_amount
    object.invoice_products.sum(&:product_fee)
  end
end
