ActiveAdmin.register Invoice do
  permit_params :amount, :clp, :settled, :r_hash, :memo, :payment_request

  index do
    id_column
    column :amount
    column :clp
    column :created_at
    column :updated_at
    column :settled
    actions
  end

  sidebar "Sold products", only: [:show] do
    sold_products = invoice
                    .invoice_products
                    .includes(user_product: :product)
                    .order('products.name ASC')
    table_for sold_products do
      column "Producto" do |invoice_product|
        user_product = invoice_product.user_product
        product = user_product.product
        link_to product.name, [:admin, user_product]
      end
      column "Precio" do |invoice_product|
        invoice_product.user_product.price
      end
    end
  end

  form do |f|
    f.inputs f.object.new_record? ? 'Crear' : 'Editar' do
      if f.object.new_record?
        f.input :amount
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
