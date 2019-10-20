class AddDispensedToInvoiceProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :invoice_products, :dispensed, :boolean, default: false
  end
end
