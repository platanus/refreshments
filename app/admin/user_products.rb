ActiveAdmin.register UserProduct do
  permit_params :name, :price, :user_id, :active, :stock, :image

  form partial: 'form'

  show do
    attributes_table do
      row :name
      row :user
      row :price
      row :active
      row :stock
      row :image do |ad|
        image_tag url_for(ad.image) if ad.image.attached?
      end
    end
  end
end
