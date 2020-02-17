class ProductObserver < PowerTypes::Observer
  after_save :broadcast_new
  def broadcast_new
    ActionCable.server.broadcast 'products', product: ProductSerializer.new(object, root: false)
  end
end
