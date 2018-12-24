class CreateWithdrawals < ActiveRecord::Migration[5.2]
  def change
    create_table :withdrawals do |t|
    	t.references :user, null: false
    	t.bigint :amount
    	t.string :aasm_state
      t.timestamps
    end
  end
end
