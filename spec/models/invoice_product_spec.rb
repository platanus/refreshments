require 'rails_helper'

RSpec.describe InvoiceProduct, type: :model do
  describe "validations" do
    it { should belong_to(:product) }
    it { should belong_to(:invoice) }
    it { should validate_presence_of(:product_price) }

    it 'has a valid factory' do
      invoice_product = build(:invoice_product)
      expect(invoice_product).to be_valid
    end
  end

  describe "before validations 'fix_product_price' hook" do
    let (:invoice) { create(:invoice) }
    let (:product) { create(:product) }
    let (:invoice_product) { create(:invoice_product, invoice: invoice, product: product) }

    it 'saves invoice product with correct price' do
      expect(invoice_product.product_price).to eq(invoice_product.product_price_initial_calc)
    end
  end
end
