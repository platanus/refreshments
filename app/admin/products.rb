ActiveAdmin.register Product do
  permit_params :name, :image

  form partial: 'form'

  show do
    attributes_table do
      row :name
      row :image do |ad|
        image_tag url_for(ad.image) if ad.image.attached?
      end
    end
  end
end
