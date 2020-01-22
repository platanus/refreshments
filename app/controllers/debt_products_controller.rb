class DebtProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    @debt_products = get_user_debts
  end

  private

  def get_user_debts
    array = []
    current_user.products.each do |product|
      array << product.debt_products
    end
    array.flatten
  end
end
