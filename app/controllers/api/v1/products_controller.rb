class Api::V1::ProductsController < Api::V1::BaseController
  def index
    render json: Product.with_price
  end
end
