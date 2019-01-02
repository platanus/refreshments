class RenameInvoiceSatoshis < ActiveRecord::Migration[5.2]
  def change
    rename_column :invoices, :satoshis, :amount
  end
end
