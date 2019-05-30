require 'rails_helper'

describe GetPricesHash do
  let(:user) { create(:user) }
  let(:product_a) { create(:product) }
  let(:product_b) { create(:product) }
  let!(:user_product_a) { create(:user_product, user: user, product: product_a, price: 1000) }
  let!(:user_product_b) { create(:user_product, user: user, product: product_b, price: 2000) }
  let(:products_hash) do
    {
      product_a.id.to_s => { 'amount' => 3, user_products: [{ price: 1000 }] },
      product_b.id.to_s => { 'amount' => 2, user_products: [{ price: 2000 }] }
    }
  end

  def perform
    described_class.for(products_hash: products_hash)
  end

  context 'with unchanged prices' do
    it 'returns correct prices hash' do
      expect(perform).to eq(
        product_a.id => 1000,
        product_b.id => 2000
      )
    end
  end

  context 'changed prices' do
    before { user_product_a.update_attributes(price: 3000) }

    it 'raises corresponding error' do
      expect { perform }
        .to raise_error('Prices in request are no longer available')
    end
  end

  context 'changed prices due to no stock' do
    before { user_product_a.update_attributes(stock: 0) }

    it 'raises corresponding error' do
      expect { perform }
        .to raise_error('Prices in request are no longer available')
    end
  end

  context 'changed prices due to inactive' do
    before { user_product_a.update_attributes(active: false) }

    it 'raises corresponding error' do
      expect { perform }
        .to raise_error('Prices in request are no longer available')
    end
  end
end
