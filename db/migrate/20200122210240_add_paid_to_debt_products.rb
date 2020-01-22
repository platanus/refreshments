class AddPaidToDebtProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :debt_products, :paid, :boolean, default: false
  end
end
