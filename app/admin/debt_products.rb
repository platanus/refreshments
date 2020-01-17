ActiveAdmin.register DebtProduct do
  permit_params :debtor, :product_id, :product_price

  form partial: 'form'

  preserve_default_filters!
  # filter :category, as: :check_boxes, collection: proc { Product.categories }
  show do
    attributes_table do
      row :debtor
      row :product_id
      row :product_price
    end
  end
end