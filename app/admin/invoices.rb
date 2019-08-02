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
    table_for sold_products do
      column "Producto" do |invoice_product|
        product = invoice_product.product
        link_to product.name, [:admin, product]
      end
      column :product_price
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
