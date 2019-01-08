class PagesController < ApplicationController
  def welcome
    return redirect_to user_products_path if current_user
  end

  def buy; end
end
