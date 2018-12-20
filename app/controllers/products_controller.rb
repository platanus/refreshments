class ProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    @products = current_user.products.all
  end

  def new
    @product = current_user.products.new
  end

  def create
    @product = current_user.products.new(product_params)
    return render "new" unless @product.save
    redirect_to user_products_path
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :image)
  end
end
