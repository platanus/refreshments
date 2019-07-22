class AddCategoryToLedgerLine < ActiveRecord::Migration[5.2]
  def change
    add_column :ledger_lines, :category, :string
  end
end
