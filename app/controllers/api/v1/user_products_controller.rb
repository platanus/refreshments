class Api::V1::UserProductsController < Api::V1::BaseController
  def index
    render json: UserProduct.all
  end

  def show
    render json: UserProduct.find(params[:id])
  end
end
