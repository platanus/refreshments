class ProductObserver < PowerTypes::Observer
  after_save :broadcast_new
  # before_create { puts "yes, you can provide a block to work with" }
  #
  # def run
  #   p object # object holds an Product instance.
  # end
  def broadcast_new
    puts "asdfsfd" + object.to_s
    ActionCable.server.broadcast 'products', product: ProductSerializer.new(object, root: false)
  end
end
