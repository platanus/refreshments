class AddProductFeeAndFeeRateToInvoiceProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :invoice_products, :product_fee, :integer, default: 0, null: false
    add_column :invoice_products, :fee_rate, :decimal, default: 0.0, null: false
  end
end
