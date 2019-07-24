class UserProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_product, only: [:edit, :update, :destroy]

  def index
    @withdrawable_amount = current_user.withdrawable_amount
    @user_products = current_user.products_with_sales.active
  end

  def new
    @user_product = current_user.user_products.new
  end

  def edit; end

  def create
    @user_product = current_user.user_products.new(permitted_params)
    if @user_product.save
      redirect_to user_products_path
    else
      render "new"
    end
  end

  def update
    if user_product.update(permitted_params)
      redirect_to user_products_path
    else
      render "edit"
    end
  end

  def destroy
    user_product.update!(active: false)
    redirect_to user_products_path
  end

  private

  def permitted_params
    params.require(:user_product).permit(:name, :price, :stock, :image, :active)
  end

  def check_user_product
    return not_found unless user_product
  end

  def user_product
    @user_product ||= current_user.user_products.find_by(id: params[:id])
  end
end
