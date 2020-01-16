class Api::V1::DebtProductsController < Api::V1::BaseController
  def create_debt_product
    debtor = create_params[:debtor]
    create_params[:products].each do |product|
      debt = DebtProduct.create(
      debtor: debtor,
      product_id: product[:product_id],
      product_price: product[:product_price]
    )
    puts 'Abajo la deuda guardada'
    puts debt
    end
  end

  private

  def create_params
    params.require(:debt_product).permit(:debtor, products: [:product_id, :product_price])
  end
end
