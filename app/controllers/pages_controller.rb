class PagesController < ApplicationController
  def welcome
    return redirect_to user_products_path if current_user
  end

  def debts_list
    @debt_products = DebtProduct.where(paid: FALSE)
  end

  def buy; end
end
