require 'rails_helper'

RSpec.describe UserProduct, type: :model do
  describe 'basic validations' do
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:stock) }
    it { should validate_numericality_of(:price) }
    it { should validate_numericality_of(:stock) }
    it { should have_many(:invoice_products) }
    it { should have_many(:invoices) }
    it { should belong_to(:user) }
    it { should belong_to(:product) }
  end

  describe 'cant change product_id validation' do
    let(:user_product) { create(:user_product) }
    let(:new_product) { create(:product) }

    it 'does not allow product change' do
      expect { user_product.update!(product: new_product) }
        .to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'adds correct error on attribute product_id' do
      user_product.update(product: new_product)
      expect(user_product.errors.messages[:product_id])
        .to include(I18n.t(:cant_change_product_reference, scope:
          [:activerecord, :errors, :models, :user_product, :attributes, :product_id]))
    end
  end
end
