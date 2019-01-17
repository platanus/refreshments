class RemoveUserFromProducts < ActiveRecord::Migration[5.2]
  def change
  	remove_reference :products, :user
  end
end
