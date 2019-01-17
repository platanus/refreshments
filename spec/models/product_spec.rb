require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'basic validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:image) }
    it { should have_many(:user_products) }
    it { should have_many(:users) }
    it { should have_many(:invoice_products) }
    it { should have_many(:invoices) }
  end

  describe 'Product#products_with_price' do
    let(:result) { Product.products_with_price }

    context 'product by one users' do
      let(:user) { create(:user_with_product) }
      let(:user_product) { user.user_products.first }
      let!(:product) { user_product.product }

      it 'returns the id of the product' do
        expect(result.first.id).to eq(product.id)
      end

      it 'returns the name of the product' do
        expect(result.first.name).to eq(product.name)
      end

      it 'returns the price of the user product' do
        expect(result.first.price).to eq(user_product.price)
      end
    end

    context 'inactive product' do
      let(:user) { create(:user) }
      let(:user_product) { create(:user_product, active: false) }

      it 'does not return inactive product' do
        expect(result.length).to eq(0)
      end
    end

    context 'product without stock' do
      let(:user) { create(:user) }
      let(:user_product) { create(:user_product, stock: 0) }

      it 'does not return product without stock' do
        expect(result.length).to eq(0)
      end
    end

    context 'product offered by two users' do
      let(:user_a) { create(:user) }
      let(:user_b) { create(:user) }
      let(:product) { create(:product) }
      let!(:user_product_a) { create(:user_product, user: user_a, product: product, price: 100) }
      let!(:user_product_b) { create(:user_product, user: user_b, product: product, price: 200) }

      it 'returns the minimun price' do
        expect(result.first.price).to eq(100)
      end

      it 'returns no duplicates' do
        expect(result.length).to eq(1)
      end

      context 'cheaper product without stock' do
        before { user_product_a.update(stock: 0) }

        it 'does not return product without stock' do
          expect(result.first.price).to eq(200)
        end
      end

      context 'cheaper product is inactive' do
        before { user_product_a.update(active: false) }

        it 'does not return inactive product' do
          expect(result.first.price).to eq(200)
        end
      end
    end

    context 'two products with one user each' do
      before do
        2.times { create(:user_with_product) }
      end

      it 'returns both products' do
        expect(result.length).to eq(2)
      end
    end

    context 'two products with two user each' do
      let(:user_a) { create(:user) }
      let(:user_b) { create(:user) }
      let(:product_a) { create(:product) }
      let(:product_b) { create(:product) }
      before do
        create(:user_product, user: user_a, product: product_a)
        create(:user_product, user: user_b, product: product_a)
        create(:user_product, user: user_a, product: product_b)
        create(:user_product, user: user_b, product: product_b)
      end

      it 'returns no duplicates' do
        expect(result.length).to eq(2)
      end
    end
  end
end
