class AddSettledToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :settled, :boolean, default: false
  end
end
