class Api::V1::DebtProductsController < Api::V1::BaseController
  def debt_products
    debt_products = create_debt_products

    respond_with debt_products: ActiveModel::ArraySerializer.new(
      debt_products, each_serializer: DebtProductSerializer
    )
  end

  private

  def create_debt_products
    create_params[:products].flat_map do |product_data|
      Array.new(product_data[:product_amount]) do |_|
        DebtProduct.create!(
          debtor: create_params[:debtor],
          product_id: product_data[:product_id],
          product_price: product_data[:product_price]
        ).tap do |debt_product|
          debt_product.product.update!(stock: debt_product.product.stock - 1)
        end
      end
    end
  end

  def create_params
    params.require(:debt_product).permit(
      :debtor, products: [:product_id, :product_price, :product_amount]
    )
  end
end
