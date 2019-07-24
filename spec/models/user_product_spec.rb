require 'rails_helper'

RSpec.describe UserProduct, type: :model do
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
    let!(:user_product_a) { create(:user_product, active: false) }
    let!(:user_product_b) { create(:user_product) }

    it 'only returns one active user product' do
      expect(UserProduct.active).to have_attributes(length: 1)
    end

    it 'returns correct user product' do
      expect(UserProduct.active.first.id).to eq(user_product_b.id)
    end
  end

  describe 'with_stock scope' do
    let!(:user_product_a) { create(:user_product, stock: 0) }
    let!(:user_product_b) { create(:user_product) }

    it 'only returns one user product with stock' do
      expect(UserProduct.with_stock).to have_attributes(length: 1)
    end

    it 'returns correct user product' do
      expect(UserProduct.with_stock.first.id).to eq(user_product_b.id)
    end
  end

  describe 'for_sale scope' do
    let!(:user_product_a) { create(:user_product, stock: 0) }
    let!(:user_product_b) { create(:user_product, active: false) }
    let!(:user_product_c) { create(:user_product) }

    it 'only returns one user product with stock' do
      expect(UserProduct.for_sale).to have_attributes(length: 1)
    end

    it 'returns correct user product' do
      expect(UserProduct.for_sale.first.id).to eq(user_product_c.id)
    end
  end
end
