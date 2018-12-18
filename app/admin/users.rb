ActiveAdmin.register User do

  permit_params :email, :password, :password_confirmation

  index do
    id_column
    column :email
    column :created_at
    column :updated_at
    actions
  end

  filter :email

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
