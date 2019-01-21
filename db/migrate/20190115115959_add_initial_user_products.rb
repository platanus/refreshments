class AddInitialUserProducts < ActiveRecord::Migration[5.2]
  def up
  	Product.all.each do |product|
  		user_id = product.user_id
  		price = product.price
  		UserProduct.create!(user_id: user_id, price: price, stock: 10000, product: product)
  	end
  end

  def down
  	UserProduct.delete_all
  end
end
