class AddWebhookUrlToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :webhook_url, :string
  end
end
