require 'rails_helper'

describe CreateInvoiceProducts do
  let(:user) { create(:user) }
  let(:user_product_a) { create(:user_product, user: user) }
  let(:user_product_b) { create(:user_product, user: user) }
  let(:product_a) { user_product_a.product }
  let(:product_b) { user_product_b.product }
  let(:prices_hash) { { product_a.id => 1000, product_b.id => 1000 } }

  def perform
    described_class.for(
      invoice: invoice,
      prices_hash: prices_hash,
      products_hash: products_hash
    )
  end

  context 'with 1 product' do
    let(:invoice) { create(:invoice) }
    let(:products_hash) { { product_a.id.to_s => { 'amount' => 1, 'price' => 1000 } } }
    let(:invoice_product) { invoice.invoice_products.first }
    before { perform }

    it 'creates correct amount of invoice products' do
      expect(InvoiceProduct.all.count).to eq(1)
    end

    it 'creates invoice product with correct invoice' do
      expect(invoice.invoice_products.count).to eq(1)
    end

    it 'creates invoice product with correct user product' do
      expect(invoice_product.user_product).to eq(user_product_a)
    end
  end

  context 'with more than 1 equal products' do
    let(:invoice) { create(:invoice, clp: 3000, amount: 300000) }
    let(:products_hash) { { product_a.id.to_s => { 'amount' => 3, 'price' => 1000 } } }
    before { perform }

    it 'creates correct amount of invoice products' do
      expect(InvoiceProduct.all.count).to eq(3)
    end

    it 'creates invoice product with correct invoice' do
      expect(invoice.invoice_products.count).to eq(3)
    end

    it 'creates the invoice products with correct user product' do
      expect(invoice.invoice_products.pluck(:user_product_id).uniq).to eq([user_product_a.id])
    end
  end

  context 'with more than 1 different products' do
    let(:invoice) { create(:invoice, clp: 5000, amount: 500000) }
    let(:products_hash) do
      {
        product_a.id.to_s => { 'amount' => 3, 'price' => 1000 },
        product_b.id.to_s => { 'amount' => 2, 'price' => 1000 }
      }
    end
    before { perform }

    it 'creates correct amount of invoice products' do
      expect(InvoiceProduct.count).to eq(5)
    end

    it 'creates invoice product with correct invoice' do
      expect(invoice.invoice_products.count).to eq(5)
    end

    it 'creates correct ammount of invoice products for each product' do
      expect(user_product_a.invoice_products.count).to eq(3)
      expect(user_product_b.invoice_products.count).to eq(2)
    end
  end

  context 'invalid products hash' do
    let(:invoice) { create(:invoice) }

    context 'it uses old structure of products hash' do
      let(:products_hash) { { product_a.id.to_s => 4 } }

      it 'raises error' do
        expect { perform }.to raise_error(TypeError)
      end
    end
  end

  context 'invalid prices hash' do
    let(:invoice) { create(:invoice) }
    let(:products_hash) { { product_a.id.to_s => { 'amount' => 4, 'price' => 1000 } } }

    context 'it uses list of hashes as prices hash' do
      let(:prices_hash) { [{ product_a.id => 1000 }, { product_b.id => 1000 }] }

      it 'raises error' do
        expect { perform }.to raise_error(NoMethodError)
      end
    end
  end

  context 'with no stock' do
    let(:invoice) { create(:invoice) }
    let(:products_hash) { { product_a.id.to_s => { 'amount' => 4, 'price' => 1000 } } }
    before { user_product_a.update(stock: 3) }

    it 'does not create any of the invoice products' do
      expect { perform }.to raise_error("Product doesn't have stock")
      expect(InvoiceProduct.all.count).to be(0)
    end
  end
end
