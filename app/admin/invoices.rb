ActiveAdmin.register Invoice do
  index do
    id_column
    column :satoshis
    column :clp
    column :created_at
    column :updated_at
    column :settled
    actions
  end
end
