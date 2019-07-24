class RemoveReferenceToProductFromUserProduct < ActiveRecord::Migration[5.2]
  def change
    remove_reference :user_products, :product
  end
end
