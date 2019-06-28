class CreateLightningNetworkWithdrawals < ActiveRecord::Migration[5.2]
  def change
    create_table :lightning_network_withdrawals do |t|
      t.string :invoice_hash, null: false
      t.string :state
      t.references :user, null: false

      t.timestamps
    end
  end
end
