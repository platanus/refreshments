require 'rails_helper'

RSpec.describe InvoiceProduct, type: :model do
  MOCKED_SATOSHI_CLP_RATIO = 5

  def mock_invoice_satoshi_clp_ratio
    allow_any_instance_of(Invoice)
      .to receive(:satoshi_clp_ratio).and_return(MOCKED_SATOSHI_CLP_RATIO)
  end

  def initialize_invoice
    mock_invoice_satoshi_clp_ratio
    create(:invoice)
  end

  def create_invoice_products(product_invoice_count)
    product_invoice_count.times do
      create(:invoice_product, invoice: invoice, user_product: user_product)
    end
  end

  describe 'basic validations' do
    it { should belong_to(:user_product) }
    it { should belong_to(:invoice) }
    it { should validate_presence_of(:product_price) }

    it 'has a valid factory' do
      invoice_product = build(:invoice_product)
      expect(invoice_product).to be_valid
    end
  end

  let(:invoice) { initialize_invoice }
  let(:user_product) { create(:user_product, stock: 3) }
  let(:invoice_product) { create(:invoice_product, invoice: invoice, user_product: user_product) }

  describe "before validations 'fix_product_price' hook" do
    it 'saves invoice product with correct price' do
      expect(invoice_product.product_price).to eq(user_product.price * MOCKED_SATOSHI_CLP_RATIO)
    end

    it 'saves invoice product with correct fee_rate' do
      expect(invoice_product.product_fee).to eq(user_product.price * invoice_product.fee_rate)
    end
  end
end
