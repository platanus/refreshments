class CreateInvoiceProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :invoice_products do |t|
      t.references :product, null: false
      t.references :invoice, null: false
      t.timestamps
    end
  end
end
