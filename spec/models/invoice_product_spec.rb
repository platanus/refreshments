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

  describe 'basic validations' do
    it { should belong_to(:user_product) }
    it { should belong_to(:invoice) }
    it { should validate_presence_of(:product_price) }

    it 'has a valid factory' do
      invoice_product = build(:invoice_product)
      expect(invoice_product).to be_valid
    end
  end

  describe "before validations 'fix_product_price' hook" do
    let(:invoice) { initialize_invoice }
    let(:user_product) { create(:user_product) }
    let(:invoice_product) { create(:invoice_product, invoice: invoice, user_product: user_product) }

    it 'saves invoice product with correct price' do
      expect(invoice_product.product_price).to eq(user_product.price * MOCKED_SATOSHI_CLP_RATIO)
    end
  end
end
