class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_product, only: [:edit, :update, :destroy]

  def index
    @withdrawable_amount = current_user.withdrawable_amount
    @products = current_user.products_with_sales.active
  end

  def new
    @product = current_user.products.new
  end

  def edit; end

  def create
    @product = current_user.products.new(permitted_params)
    if @product.save
      redirect_to user_products_path
    else
      render "new"
    end
  end

  def update
    if product.update(permitted_params)
      redirect_to user_products_path
    else
      render "edit"
    end
  end

  def destroy
    product.update!(active: false)
    redirect_to user_products_path
  end

  private

  def permitted_params
    params
      .require(:product)
      .permit(:name, :price, :stock, :image, :category, :fee_percentage, :active)
  end

  def check_product
    return not_found unless product
  end

  def product
    @product ||= current_user.products.find_by(id: params[:id])
  end
end
