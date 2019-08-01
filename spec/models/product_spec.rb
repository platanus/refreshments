require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'basic validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:stock) }
    it { should validate_numericality_of(:price) }
    it { should validate_numericality_of(:stock) }
    it { should validate_presence_of(:image) }
    it { should have_many(:invoice_products) }
    it { should have_many(:invoices) }
    it { should belong_to(:user) }
  end

  describe 'active scope' do
    let!(:product_a) { create(:product, active: false) }
    let!(:product_b) { create(:product) }

    it 'only returns one active product' do
      expect(Product.active).to have_attributes(length: 1)
    end

    it 'returns correct product' do
      expect(Product.active.first.id).to eq(product_b.id)
    end
  end

  describe 'with_stock scope' do
    let!(:product_a) { create(:product, stock: 0) }
    let!(:product_b) { create(:product) }

    it 'only returns one product with stock' do
      expect(Product.with_stock).to have_attributes(length: 1)
    end

    it 'returns correct product' do
      expect(Product.with_stock.first.id).to eq(product_b.id)
    end
  end

  describe 'for_sale scope' do
    let!(:product_a) { create(:product, stock: 0) }
    let!(:product_b) { create(:product, active: false) }
    let!(:product_c) { create(:product) }

    it 'only returns one product with stock' do
      expect(Product.for_sale).to have_attributes(length: 1)
    end

    it 'returns correct product' do
      expect(Product.for_sale.first.id).to eq(product_c.id)
    end
  end

  describe '#set_fee_percentage=' do
    let(:value) { 10 }
    let(:product) { create(:product) }

    def perform
      product.fee_percentage = value
    end

    it 'sets the fee_rate' do
      expect { perform }.to change(product, :fee_rate).from(0).to(0.1)
    end
  end
end
