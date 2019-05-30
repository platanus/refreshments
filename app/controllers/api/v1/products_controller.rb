class Api::V1::ProductsController < Api::V1::BaseController
  def index
    render json: Product.all
  end

  def get
    render json: Product.find(params[:product_id])
  end
end
