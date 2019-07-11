class ProductsController < ApplicationController
  before_action :authenticate_user!

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(create_params)
    if @product.save
      redirect_to new_user_product_path
    else
      render "new"
    end
  end

  private

  def create_params
    params.require(:product).permit(:name, :image)
  end
end
