ActiveAdmin.register User do
  permit_params :name, :email, :password, :password_confirmation

  index do
    id_column
    column :name
    column :email
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :email

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
