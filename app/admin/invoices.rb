ActiveAdmin.register Invoice do
  permit_params :satoshis, :clp, :settled, :r_hash, :memo, :payment_request

  index do
    id_column
    column :satoshis
    column :clp
    column :created_at
    column :updated_at
    column :settled
    actions
  end

  sidebar "Sold products", only: [:show] do
    table_for invoice.products.order('name ASC') do
      column "Product" do |product|
        link_to product.name, [:admin, product]
      end
      column :price
    end
  end

  form do |f|
    f.inputs f.object.new_record? ? 'Crear' : 'Editar' do
      if f.object.new_record?
        f.input :satoshis
        f.input :clp
        f.input :payment_request
        f.input :r_hash
        f.input :memo
      end
      f.input :settled
    end
    f.actions
  end
end
