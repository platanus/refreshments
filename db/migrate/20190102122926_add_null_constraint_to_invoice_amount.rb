class AddNullConstraintToInvoiceAmount < ActiveRecord::Migration[5.2]
  def change
  	change_column :invoices, :amount, :integer, null: false
  end
end
