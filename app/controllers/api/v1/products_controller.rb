class Api::V1::ProductsController < Api::V1::BaseController
  def index
    render json: Product.all
  end

  def show
    render json: Product.find(params[:id])
  end

  def seller
    render json: product.user
  end

  private

  def product
    @product ||= Product.find(params[:product_id] || params[:id])
  end
end
