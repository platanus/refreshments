class DropProducts < ActiveRecord::Migration[5.2]
  def change
    drop_table :products do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
