class CreateWithdrawals < ActiveRecord::Migration[5.2]
  def change
    create_table :withdrawals do |t|
    	t.references :user, null: false
    	t.integer :amount
    	t.string :aasm_state
    	t.string :btc_address
      t.timestamps
    end
  end
end
