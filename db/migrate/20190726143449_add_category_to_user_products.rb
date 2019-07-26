class AddCategoryToUserProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :user_products, :category, :integer, null: false, default: 2
  end
end
