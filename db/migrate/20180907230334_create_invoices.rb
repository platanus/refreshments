class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.integer :satoshis
      t.integer :clp
      t.string :payment_request
      t.string :r_hash
      t.string :memo

      t.timestamps
    end
  end
end
