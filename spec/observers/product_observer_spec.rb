require 'rails_helper'

describe ProductObserver do
  def trigger(_type, _event)
    described_class.trigger(_type, _event, product)
  end

  let(:product) { create(:product) }
  let(:serialized_product) { ProductSerializer.new(product, root: false) }

  context 'when product is saved' do
    before do
      allow(ActionCable.server).to receive(:broadcast)
      allow(ProductSerializer).to receive(:new).and_return(serialized_product)
    end

    it 'triggers broadcast after saving product' do
      trigger(:after, :save)
      expect(ActionCable.server).to have_received(:broadcast).with('products',
        product: serialized_product)
    end
  end
end
