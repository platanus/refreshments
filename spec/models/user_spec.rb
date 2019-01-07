require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:user_with_product) { create_user_with_product(10000) }
  let(:user_with_invoice) { create_user_with_invoice(10000, 10000, 500000) }

  describe "validations" do
    it { should have_many(:products) }
    it { should have_many(:withdrawals) }
  end

  describe "#total_sales" do
    context "user has no sales" do
      it { expect(user.total_sales).to be(0) }
    end

    context "user has only unsettled sales" do
      before do
        5.times do |i|
          invoice = create(:invoice, clp: 10000, amount: 10000 * (i + 1), settled: false)
          create(:invoice_product, product: user_with_product.products.first, invoice: invoice)
        end
      end

      it { expect(user_with_product.total_sales).to be(0) }
    end

    context "user has 1 sale of 1 product" do
      it { expect(user_with_invoice.total_sales).to be(500000) }
    end

    context "user has 5 sales of 1 product" do
      before do
        5.times do |i|
          invoice = create(:invoice, clp: 10000, amount: 10000 * (i + 1))
          create(:invoice_product, product: user_with_product.products.first, invoice: invoice)
        end
      end

      it { expect(user_with_product.total_sales).to be(150000) }
    end

    context "user has 1 sale of 5 different products" do
      before do
        invoice = create(:invoice, clp: 150000, amount: 250000)
        5.times do |i|
          product = create(:product, user: user, price: 10000 * (i + 1))
          create(:invoice_product, product: product, invoice: invoice)
        end
      end

      it { expect(user.total_sales).to be_within(5).of(250000) }
    end

    context "user has 5 sales of 5 different products" do
      before do
        5.times do |i|
          product_price = 10000 * (i + 1)
          product = create(:product, user: user, price: product_price)
          invoice = create(:invoice, clp: product_price, amount: 50000)
          create(:invoice_product, product: product, invoice: invoice)
        end
      end

      it { expect(user.total_sales).to be(250000) }
    end

    context "2 sales of 4 different products with different owners" do
      let(:user_a) { create(:user) }
      let!(:user_b) { create(:user, email: "test_2@email.com") }
      let!(:product_a) { create(:product, user: user_a, price: 10000) }
      let!(:product_b) { create(:product, user: user_a, price: 20000) }
      let!(:product_c) { create(:product, user: user_b, price: 30000) }
      let!(:product_d) { create(:product, user: user_b, price: 40000) }
      let!(:invoice_a) { create(:invoice, clp: 40000, amount: 90000) }
      let!(:invoice_b) { create(:invoice, clp: 60000, amount: 110000) }
      let!(:invoice_product_a) { create(:invoice_product, product: product_a, invoice: invoice_a) }
      let!(:invoice_product_b) { create(:invoice_product, product: product_b, invoice: invoice_b) }
      let!(:invoice_product_c) { create(:invoice_product, product: product_c, invoice: invoice_a) }
      let!(:invoice_product_d) { create(:invoice_product, product: product_d, invoice: invoice_b) }

      it { expect(user_a.total_sales).to be_within(2).of(59165) }
      it { expect(user_b.total_sales).to be_within(3).of(140830) }
    end
  end

  describe "#total_withdrawal" do
    let(:user) { user_with_invoice }
    context "user has no withdrawals" do
      it { expect(user.total_withdrawals).to be(0) }
    end

    context "user has 1 pending withdrawal" do
      before { create_withdrawal_without_after_commit_callback }

      it { expect(user.total_withdrawals).to be(50000) }
    end

    context "user has 1 confirm withdrawal" do
      before { create_withdrawal_without_after_commit_callback.confirm! }

      it { expect(user.total_withdrawals).to be(50000) }
    end

    context "user has 3 withdrawals with different states" do
      before do
        create_withdrawal_without_after_commit_callback
        create_withdrawal_without_after_commit_callback.confirm!
        create_withdrawal_without_after_commit_callback.reject!
      end

      it { expect(user.total_withdrawals).to be(100000) }
    end
  end

  describe "#total_pending_withdrawals" do
    let(:user) { user_with_invoice }

    context "user has no pending withdrawals" do
      before do
        create_withdrawal_without_after_commit_callback.confirm!
        create_withdrawal_without_after_commit_callback.reject!
      end

      it { expect(user.total_pending_withdrawals).to be(0) }
    end

    context "user has pending withdrawals" do
      before do
        create_withdrawal_without_after_commit_callback
        create_withdrawal_without_after_commit_callback
        create_withdrawal_without_after_commit_callback.confirm!
        create_withdrawal_without_after_commit_callback.reject!
      end

      it { expect(user.total_pending_withdrawals).to be(100000) }
    end
  end

  describe "#total_confirmed_withdrawals" do
    let(:user) { user_with_invoice }

    context "user has no confirmed withdrawals" do
      before do
        create_withdrawal_without_after_commit_callback
        create_withdrawal_without_after_commit_callback.reject!
      end

      it { expect(user.total_confirmed_withdrawals).to be(0) }
    end

    context "user has confirmed withdrawals" do
      before do
        create_withdrawal_without_after_commit_callback
        create_withdrawal_without_after_commit_callback.confirm!
        create_withdrawal_without_after_commit_callback.confirm!
        create_withdrawal_without_after_commit_callback.reject!
      end

      it { expect(user.total_confirmed_withdrawals).to be(100000) }
    end
  end

  describe "#withdrawable_amount" do
    context "user has no sales and no withdrawals" do
      it { expect(user.withdrawable_amount).to be(0) }
    end

    context "user has sales and withdrawals" do
      before do
        5.times do
          product = create(:product, user: user, price: 10000)
          invoice = create(:invoice, clp: 10000, amount: 100000)
          create(:invoice_product, product: product, invoice: invoice)
          create_withdrawal_without_after_commit_callback.confirm!
        end
      end

      it { expect(user.withdrawable_amount).to be(250000) }
    end
  end
end
