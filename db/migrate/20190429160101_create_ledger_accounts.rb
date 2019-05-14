class CreateLedgerAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :ledger_accounts do |t|
      t.string :category
      t.references :accountable, polymorphic: true
      t.integer :balance, default: 0
      t.timestamps
    end
  end
end
