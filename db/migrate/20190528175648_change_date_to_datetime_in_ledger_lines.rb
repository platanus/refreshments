class ChangeDateToDatetimeInLedgerLines < ActiveRecord::Migration[5.2]
  def up
    change_column :ledger_lines, :date, :datetime
  end

  def down
    change_column :ledger_lines, :date, :date
  end
end
