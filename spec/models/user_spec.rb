require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should have_many(:products) }
  end

  describe "#total_sales" do
    context "user has no sales" do
      let(:user) { create(:user) }

      it { expect(user.total_sales).to be(0) }
    end

    context "user has 1 sale of 1 product" do
      let(:user) { create(:user) }
      let!(:product) { create(:product, user: user, price: 100) }
      let!(:invoice) { create(:invoice) }
      let!(:invoice_product) { create(:invoice_product, product: product, invoice: invoice) }

      it { expect(user.total_sales).to be(100) }
    end

    context "user has 5 sales of 1 product" do
      let(:user) { create(:user) }
      let!(:product) { create(:product, user: user, price: 100) }

      before do
        5.times { create(:invoice_product, product: product, invoice: create(:invoice)) }
      end

      it { expect(user.total_sales).to be(500) }
    end

    context "user has 5 sales of 5 different products" do
      let(:user) { create(:user) }

      before do
        5.times do
          product = create(:product, user: user, price: 100)
          invoice = create(:invoice)
          create(:invoice_product, product: product, invoice: invoice)
        end
      end

      it { expect(user.total_sales).to be(500) }
    end

    context "user has 25 sales of 5 different products (5 for each product)" do
      let(:user) { create(:user) }

      before do
        5.times do
          product = create(:product, user: user, price: 100)
          5.times do
            invoice = create(:invoice)
            create(:invoice_product, product: product, invoice: invoice)
          end
        end
      end

      it { expect(user.total_sales).to be(2500) }
    end
  end
end
