class AddFeeRateToUserProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :user_products, :fee_rate, :decimal, default: 0.0, null: false
  end
end
