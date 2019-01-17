class RemoveReferenceToProductFromInvoiceProduct < ActiveRecord::Migration[5.2]
  def change
  	remove_reference :invoice_products, :product
  end
end
