class CreateUserProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :user_products do |t|
    	t.references :user, null: false
    	t.references :product, null: false
    	t.integer :price, null: false
    	t.integer :stock, null: false
    	t.boolean :active, default: true
      t.timestamps
    end
  end
end
