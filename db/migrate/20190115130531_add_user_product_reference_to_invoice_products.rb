class AddUserProductReferenceToInvoiceProducts < ActiveRecord::Migration[5.2]
  def change
  	add_reference :invoice_products, :user_product
  end
end
