class GetPricesHash < PowerTypes::Command.new(:products_hash)
  def perform
    get_prices_hash
  end

  private

  def get_prices_hash
    check_prices!
    prices_hash
  end

  def check_prices!
    @products_hash.each do |id, data|
      if data['price'] != prices_hash[id.to_i]
        raise 'Prices in request are no longer available'
      end
    end
  end

  def prices_hash
    @prices_hash ||= Product
                     .with_price
                     .where(id: @products_hash.keys)
                     .reduce({}) { |acc, prod| acc.update(prod.id => prod.price) }
  end
end
