require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'basic validations' do
    it { should validate_presence_of(:clp) }
    it { should validate_presence_of(:memo) }
    it { should validate_presence_of(:payment_request) }
    it { should validate_presence_of(:r_hash) }
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount) }
    it { should validate_numericality_of(:clp) }
    it { should have_many(:invoice_products) }
    it { should have_many(:products) }
  end

  describe 'satoshi_clp_ratio' do
    describe 'case integer' do
      let(:invoice) { create(:invoice, clp: 100, amount: 500) }

      it { expect(invoice.satoshi_clp_ratio).to eq(5) }
    end

    describe 'case float' do
      let(:invoice) { create(:invoice, clp: 500, amount: 100) }

      it { expect(invoice.satoshi_clp_ratio).to eq(0.2) }
    end
  end
end
