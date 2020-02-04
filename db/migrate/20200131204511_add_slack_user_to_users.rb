class AddSlackUserToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :slack_user, :string, default: ""
  end
end
