class CreateLedgerLines < ActiveRecord::Migration[5.2]
  def change
    create_table :ledger_lines do |t|
      t.references :ledger_account, foreign_key: true
      t.references :accountable, polymorphic: true
      t.date :date
      t.integer :amount
      t.integer :balance, default: 0
      t.timestamps
    end
  end
end
