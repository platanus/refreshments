class UserProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_product, only: %i[edit show update destroy]

  def index
    @withdrawable_amount = current_user.withdrawable_amount
    @total_sales = current_user.total_sales
    @user_products = current_user.products_with_sales.active
  end

  def new
    @user_product = current_user.user_products.new
    @products = Product.order('name ASC')
  end

  def edit; end

  def create
    @user_product = current_user.user_products.new(create_params)
    if @user_product.save
      redirect_to user_products_path
    else
      render "new"
    end
  end

  def update
    if user_product.update_attributes(update_params)
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

  def user_product_basic_params
    params.require(:user_product).permit(:price, :stock)
  end

  def create_params
    params
      .require(:user_product).permit(:product_id)
      .merge(user_product_basic_params)
  end

  def update_params
    params
      .require(:user_product).permit(:active)
      .merge(user_product_basic_params)
  end

  def check_user_product
    return not_found unless user_product
  end

  def user_product
    @user_product ||= current_user.user_products.find_by(id: params[:id])
  end
end
