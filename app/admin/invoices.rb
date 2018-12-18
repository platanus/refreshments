ActiveAdmin.register Invoice do
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
        link_to product.name, [ :admin, product ]
      end
      column :price
    end
  end
end
