class SetUserProductToProductInvoice < ActiveRecord::Migration[5.2]
  def up
  	Product.all.each do |product|
  		invoice_products = InvoiceProduct.where(product_id: product.id)
  		invoice_products.each do |invoice_product|
	  		user_product = product.user_products.first
	  		invoice_product.update(user_product_id: user_product.id)
	  	end
  	end
  end

  def down
  	InvoiceProduct.all.each do |invoice_product|
  		invoice_product.update(user_product_id: nil)
  	end
  end
end
