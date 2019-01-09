class AddProductPriceToInvoiceProduct < ActiveRecord::Migration[5.2]
  def up
  	add_column :invoice_products, :product_price, :integer
  	Product.all.each do |product|
  		product.invoice_products.each do |invoice_product|
        invoice = invoice_product.invoice
  			invoice_product.update(product_price: product.price * invoice.satoshi_clp_ratio)
  		end
  	end
  	change_column_null :invoice_products, :product_price, false
  end

  def down
  	remove_column :invoice_products, :product_price
  end
end
