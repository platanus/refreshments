require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should have_many(:products) }
    it { should have_many(:withdrawals) }
  end

  describe "#total_sales" do
    context "user has no sales" do
      let(:user) { create(:user) }

      it { expect(user.total_sales).to be(0) }
    end

    context "user has only unsettled sales" do
      let(:user) { create_user_with_product(100) }

      before do
        5.times do |i|
          invoice = create(:invoice, clp: 100, amount: 100 * (i + 1), settled: false)
          create(:invoice_product, product: user.products.first, invoice: invoice)
        end
      end

      it { expect(user.total_sales).to be(0) }
    end

    context "user has 1 sale of 1 product" do
      let(:user) { create_user_with_invoice(100, 100, 500) }
      it { expect(user.total_sales).to be(500) }
    end

    context "user has 5 sales of 1 product" do
      let(:user) { create_user_with_product(100) }

      before do
        5.times do |i|
          invoice = create(:invoice, clp: 100, amount: 100 * (i + 1))
          create(:invoice_product, product: user.products.first, invoice: invoice)
        end
      end

      it { expect(user.total_sales).to be(1500) }
    end

    context "user has 1 sale of 5 different products" do
      let(:user) { create(:user) }

      before do
        invoice = create(:invoice, clp: 1500, amount: 2500)
        5.times do |i|
          product = create(:product, user: user, price: 100 * (i + 1))
          create(:invoice_product, product: product, invoice: invoice)
        end
      end

      it { expect(user.total_sales).to be_within(5).of(2500) }
    end

    context "user has 5 sales of 5 different products" do
      let(:user) { create(:user) }

      before do
        5.times do |i|
          product_price = 100 * (i + 1)
          product = create(:product, user: user, price: product_price)
          invoice = create(:invoice, clp: product_price, amount: 500)
          create(:invoice_product, product: product, invoice: invoice)
        end
      end

      it { expect(user.total_sales).to be(2500) }
    end

    context "2 sales of 4 different products with different owners" do
      let(:user_a) { create(:user) }
      let!(:user_b) { create(:user, email: "test_2@email.com") }
      let!(:product_a) { create(:product, user: user_a, price: 100) }
      let!(:product_b) { create(:product, user: user_a, price: 200) }
      let!(:product_c) { create(:product, user: user_b, price: 300) }
      let!(:product_d) { create(:product, user: user_b, price: 400) }
      let!(:invoice_a) { create(:invoice, clp: 400, amount: 900) }
      let!(:invoice_b) { create(:invoice, clp: 600, amount: 1100) }
      let!(:invoice_product_a) { create(:invoice_product, product: product_a, invoice: invoice_a) }
      let!(:invoice_product_b) { create(:invoice_product, product: product_b, invoice: invoice_b) }
      let!(:invoice_product_c) { create(:invoice_product, product: product_c, invoice: invoice_a) }
      let!(:invoice_product_d) { create(:invoice_product, product: product_d, invoice: invoice_b) }

      it { expect(user_a.total_sales).to be_within(2).of(592) }
      it { expect(user_b.total_sales).to be_within(3).of(1408) }
    end
  end

  describe "#total_withdrawal" do
    context "user has no withdrawals" do
      let(:user) { create(:user) }

      it { expect(user.total_withdrawals).to be(0) }
    end

    context "user has 1 withdrawal" do
      let(:user) { create_user_with_invoice(100, 100, 5000) }
      before { create(:withdrawal, amount: 500, user: user) }

      it { expect(user.total_withdrawals).to be(500) }
    end

    context "user has many withdrawals" do
      let(:user) { create_user_with_invoice(100, 100, 5000) }
      before do
        5.times { create(:withdrawal, amount: 500, user: user) }
      end

      it { expect(user.total_withdrawals).to be(2500) }
    end

    context "user has 3 withdrawals with different states" do
      let(:user) { create_user_with_invoice(100, 100, 5000) }
      before do
        create(:withdrawal, amount: 500, user: user)
        create(:withdrawal, amount: 500, user: user).confirm!
        create(:withdrawal, amount: 500, user: user).reject!
      end

      it { expect(user.total_withdrawals).to be(1000) }
    end
  end

  describe "#total_pending_withdrawals" do
    context "user has no pending withdrawals" do
      let(:user) { create_user_with_invoice(100, 100, 5000) }
      before do
        create(:withdrawal, amount: 500, user: user).confirm!
        create(:withdrawal, amount: 500, user: user).reject!
      end

      it { expect(user.total_pending_withdrawals).to be(0) }
    end

    context "user has pending withdrawals" do
      let(:user) { create_user_with_invoice(100, 100, 5000) }
      before do
        create(:withdrawal, amount: 500, user: user)
        create(:withdrawal, amount: 500, user: user)
        create(:withdrawal, amount: 500, user: user).confirm!
        create(:withdrawal, amount: 500, user: user).reject!
      end

      it { expect(user.total_pending_withdrawals).to be(1000) }
    end
  end

  describe "#total_confirmed_withdrawals" do
    context "user has no confirmed withdrawals" do
      let(:user) { create_user_with_invoice(100, 100, 5000) }
      before do
        create(:withdrawal, amount: 500, user: user)
        create(:withdrawal, amount: 500, user: user).reject!
      end

      it { expect(user.total_confirmed_withdrawals).to be(0) }
    end

    context "user has confirmed withdrawals" do
      let(:user) { create_user_with_invoice(100, 100, 5000) }
      before do
        create(:withdrawal, amount: 500, user: user)
        create(:withdrawal, amount: 500, user: user).confirm!
        create(:withdrawal, amount: 500, user: user).confirm!
        create(:withdrawal, amount: 500, user: user).reject!
      end

      it { expect(user.total_confirmed_withdrawals).to be(1000) }
    end
  end

  describe "#withdrawable_amount" do
    context "user has no sales and no withdrawals" do
      let(:user) { create(:user) }

      it { expect(user.withdrawable_amount).to be(0) }
    end

    context "user has sales and withdrawals" do
      let(:user) { create(:user) }
      before do
        5.times do
          product = create(:product, user: user, price: 100)
          invoice = create(:invoice, clp: 100, amount: 1000)
          create(:invoice_product, product: product, invoice: invoice)
          create(:withdrawal, amount: 500, user: user)
        end
      end

      it { expect(user.withdrawable_amount).to be(2500) }
    end
  end
end
