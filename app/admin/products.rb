ActiveAdmin.register Product do
  permit_params :name, :price, :fee_rate, :user_id, :active, :stock, :category, :image

  form partial: 'form'

  preserve_default_filters!
  filter :category, as: :check_boxes, collection: proc { Product.categories }
  show do
    attributes_table do
      row :name
      row :user
      row :price
      row :fee_rate
      row :active
      row :stock
      row :category
      row :image do |ad|
        image_tag url_for(ad.image) if ad.image.attached?
      end
    end
  end
end
