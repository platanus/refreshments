class DebtProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    @debt_products = user_debts
  end

  def mark_as_paid
    @debt_product = DebtProduct.find(params[:debt_product_id])
    @debt_product.update!(paid: true)
    redirect_to user_debt_products_path
  end

  private

  def user_debts
    DebtProduct.where(product_id: current_user.products.ids).order(updated_at: :desc)
  end
end
