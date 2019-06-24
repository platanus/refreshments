class AddAmountAndMemoToLightningNetworkWithdrawals < ActiveRecord::Migration[5.2]
  def change
    add_column :lightning_network_withdrawals, :amount, :int
    add_column :lightning_network_withdrawals, :memo, :string
  end
end
