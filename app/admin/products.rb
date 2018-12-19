ActiveAdmin.register Product do
  permit_params :name, :price, :image, :active, :user_id

  form partial: 'form'

  show do
    attributes_table do
      row :name
      row :price
      row :active
      row :image do |ad|
        image_tag url_for(ad.image)
      end
      row :user
    end
  end
end
