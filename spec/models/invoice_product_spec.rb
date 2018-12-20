require 'rails_helper'

RSpec.describe InvoiceProduct, type: :model do
  describe "validations" do
    it { should belong_to(:product) }
    it { should belong_to(:invoice) }

    it 'has a valid factory' do
      invoice_product = build(:invoice_product)
      expect(invoice_product).to be_valid
    end
  end
end
