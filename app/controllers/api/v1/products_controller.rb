class Api::V1::ProductsController < Api::V1::BaseController
  def index
    render json: Product.all
  end

  def show
    render json: Product.find(params[:id])
  end

  def get_seller
    render json: Product.find(params[:product_id]).user
  end
end
