ActiveAdmin.register UserProduct do
  permit_params :price, :user_id, :product_id, :active, :stock

  form partial: 'form'

  show do
    attributes_table do
      row :user
      row :product
      row :price
      row :active
      row :stock
    end
  end
end
