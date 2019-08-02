class SetProductsAttachments < ActiveRecord::Migration[5.2]
  def up
    ActiveStorage::Attachment.where(record_type: 'Product').delete_all
    ActiveStorage::Attachment.where(record_type: 'UserProduct').update(record_type: 'Product')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
