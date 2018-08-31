ActiveAdmin.register Product do
  permit_params :name, :price, :image

  form partial: 'form'

  show do
    attributes_table do
      row :name
      row :price
      row :image do |ad|
        image_tag url_for(ad.image)
      end
    end
  end
end
