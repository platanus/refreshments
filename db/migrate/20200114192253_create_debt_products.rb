class CreateDebtProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :debt_products do |t|
      t.string :debtor
      t.bigint :product_id
      t.integer :product_price

      t.timestamps
    end
  end
end
