class AddNameToUserProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :user_products, :name, :string
  end
end
