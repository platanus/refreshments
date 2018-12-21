class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_product, only: %i[edit show update destroy]

  def index
    @products = current_user.products.includes(:invoice_products)
  end

  def new
    @product = current_user.products.new
  end

  def create
    @product = current_user.products.new(create_params)
    if @product.save
      redirect_to user_products_path
    else
      render "new"
    end
  end

  def show
    @sales = product.invoice_products.count
  end

  def update
    if product.update_attributes(update_params)
      redirect_to user_products_path
    else
      render "edit"
    end
  end

  def destroy
    product.destroy!
    redirect_to user_products_path
  end

  private

  def create_params
    params.require(:product).permit(:name, :price, :image)
  end

  def update_params
    params.require(:product).permit(:active).merge(create_params)
  end

  def check_product
    return not_found unless product
  end

  def product
    @product ||= current_user.products.find_by(id: params[:id])
  end
end
