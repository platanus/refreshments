class SetNameAndImageToUserProducts < ActiveRecord::Migration[5.2]
  def up
    UserProduct.all.each do |user_product|
      user_product.name = user_product.product.name
      user_product.image.attach(user_product.product.image.blob)
      user_product.save
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
