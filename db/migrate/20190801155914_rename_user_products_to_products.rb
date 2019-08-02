class RenameUserProductsToProducts < ActiveRecord::Migration[5.2]
  def change
    rename_table :user_products, :products
    rename_column :invoice_products, :user_product_id, :product_id
  end
end
