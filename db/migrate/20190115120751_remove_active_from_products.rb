class RemoveActiveFromProducts < ActiveRecord::Migration[5.2]
  def change
  	remove_column :products, :active, :boolean
  end
end
