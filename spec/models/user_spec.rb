require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:user_with_product) { create(:user_with_product) }
  let(:user_with_invoice) { create(:user_with_invoice) }

  describe 'basic validations' do
    it { should have_many(:products) }
    it { should have_many(:withdrawals) }
  end

  describe '#total_sales' do
    context 'user has no sales' do
      it { expect(user.total_sales).to be(0) }
    end

    context 'user has only unsettled sales' do
      before do
        5.times do |_|
          create(:invoice_product,
            user_product: user_with_product.user_products.first,
            invoice_settled: false)
        end
      end

      it { expect(user_with_product.total_sales).to be(0) }
    end

    context 'user has 1 sale of 1 product' do
      it { expect(user_with_invoice.total_sales).to be(100000) }
    end

    context 'user has 5 sales of 1 product' do
      before do
        5.times do |_|
          create(:invoice_product, user_product: user_with_product.user_products.first)
        end
      end

      it { expect(user_with_product.total_sales).to be(500000) }
    end

    context 'user has 1 sale of 5 different products' do
      before do
        invoice = create(:invoice, clp: 5000, amount: 500000)
        5.times do |_|
          product = create(:user_product, user: user)
          create(:invoice_product, user_product: product, invoice: invoice)
        end
      end

      it { expect(user.total_sales).to be(500000) }
    end

    context 'user has 5 sales of 5 different products' do
      let(:user_with_invoices) { create(:user_with_invoice, product_count: 5) }

      it { expect(user_with_invoices.total_sales).to be(500000) }
    end

    context '2 sales of 4 different products with different owners' do
      let!(:user_a) { create(:user) }
      let!(:user_b) { create(:user) }
      let!(:user_product_a) { create(:user_product, user: user_a) }
      let!(:user_product_b) { create(:user_product, user: user_a) }
      let!(:user_product_c) { create(:user_product, user: user_b) }
      let!(:user_product_d) { create(:user_product, user: user_b) }
      let!(:invoice_a) { create(:invoice, clp: 2000, amount: 200000) }
      let!(:invoice_b) { create(:invoice, clp: 2000, amount: 200000) }
      before do
        create(:invoice_product, user_product: user_product_a, invoice: invoice_a)
        create(:invoice_product, user_product: user_product_b, invoice: invoice_b)
        create(:invoice_product, user_product: user_product_c, invoice: invoice_a)
        create(:invoice_product, user_product: user_product_d, invoice: invoice_b)
      end

      it { expect(user_a.total_sales).to be(200000) }
      it { expect(user_b.total_sales).to be(200000) }
    end
  end

  describe 'withdrawal functions' do
    before do
      allow_any_instance_of(Withdrawal)
        .to receive(:add_job_to_withdrawal_requests_worker)
        .and_return(true)
    end

    describe '#total_withdrawal' do
      context 'user has no withdrawals' do
        it { expect(user_with_invoice.total_withdrawals).to be(0) }
      end

      context 'user has 1 pending withdrawal' do
        before { create(:withdrawal, user: user_with_invoice) }

        it { expect(user_with_invoice.total_withdrawals).to be(10000) }
      end

      context 'user has 1 confirm withdrawal' do
        before { create(:withdrawal, user: user_with_invoice).confirm! }

        it { expect(user_with_invoice.total_withdrawals).to be(10000) }
      end

      context 'user has 3 withdrawals with different states' do
        before do
          create(:withdrawal, user: user_with_invoice)
          create(:withdrawal, user: user_with_invoice).confirm!
          create(:withdrawal, user: user_with_invoice).reject!
        end

        it { expect(user_with_invoice.total_withdrawals).to be(20000) }
      end
    end

    describe '#total_pending_withdrawals' do
      context 'user has no pending withdrawals' do
        before do
          create(:withdrawal, user: user_with_invoice).confirm!
          create(:withdrawal, user: user_with_invoice).reject!
        end

        it { expect(user_with_invoice.total_pending_withdrawals).to be(0) }
      end

      context 'user has pending withdrawals' do
        before do
          create(:withdrawal, user: user_with_invoice)
          create(:withdrawal, user: user_with_invoice)
          create(:withdrawal, user: user_with_invoice).confirm!
          create(:withdrawal, user: user_with_invoice).reject!
        end

        it { expect(user_with_invoice.total_pending_withdrawals).to be(20000) }
      end
    end

    describe '#total_confirmed_withdrawals' do
      let(:user) { user_with_invoice }

      context 'user has no confirmed withdrawals' do
        before do
          create(:withdrawal, user: user_with_invoice)
          create(:withdrawal, user: user_with_invoice).reject!
        end

        it { expect(user_with_invoice.total_confirmed_withdrawals).to be(0) }
      end

      context 'user has confirmed withdrawals' do
        before do
          create(:withdrawal, user: user_with_invoice)
          create(:withdrawal, user: user_with_invoice).confirm!
          create(:withdrawal, user: user_with_invoice).confirm!
          create(:withdrawal, user: user_with_invoice).reject!
        end

        it { expect(user_with_invoice.total_confirmed_withdrawals).to be(20000) }
      end
    end

    describe '#withdrawable_amount' do
      context 'user has no sales and no withdrawals' do
        it { expect(user.withdrawable_amount).to be(0) }
      end

      context 'user has sales and withdrawals' do
        before do
          5.times do
            create(:withdrawal, user: user_with_invoice).confirm!
          end
        end

        it { expect(user_with_invoice.withdrawable_amount).to be(50000) }
      end
    end
  end

  describe '#products_with_sales' do
    context 'user with 1 product and 0 invoices' do
      let(:products_with_sales) { user_with_product.products_with_sales }

      it 'returns product in spite of not having any invoices' do
        expect(products_with_sales.length).to eq(1)
      end

      it 'sets correct total_count' do
        expect(products_with_sales.first.total_count).to eq(0)
      end

      it 'sets correct total_satoshi' do
        expect(products_with_sales.first.total_satoshi).to eq(0)
      end

      it 'return correct product_name' do
        expect(products_with_sales.first.product_name).to eq('custom product name')
      end

      it 'has every necessary product attribute' do
        expect(products_with_sales.first)
          .to have_attributes(price: 1000, active: true)
      end
    end

    context 'user with 1 product and 1 unsettled invoice' do
      let(:user_with_unsettled_invoice) { create(:user_with_invoice, invoice_settled: false) }
      let(:products_with_sales) { user_with_unsettled_invoice.products_with_sales }

      it 'returns product in spite of not having any settled invoices' do
        expect(products_with_sales.length).to eq(1)
      end

      it 'sets correct total_count' do
        expect(products_with_sales.first.total_count).to eq(0)
      end

      it 'sets correct total_satoshi' do
        expect(products_with_sales.first.total_satoshi).to eq(0)
      end

      it 'return correct product_name' do
        expect(products_with_sales.first.product_name).to eq('custom product name')
      end

      it 'has every necessary product attribute' do
        expect(products_with_sales.first)
          .to have_attributes(price: 1000, active: true)
      end
    end

    context 'user with 1 product and 1 settled invoice' do
      let(:products_with_sales) { user_with_invoice.products_with_sales }

      it 'returns array with 1 element' do
        expect(products_with_sales.length).to eq(1)
      end

      it 'has attribute total_satoshi with correct value' do
        expect(products_with_sales.first.total_satoshi).to eq(100000)
      end

      it 'has attribute total_count with correct value' do
        expect(products_with_sales.first.total_count).to eq(1)
      end

      it 'return correct product_name' do
        expect(products_with_sales.first.product_name).to eq('custom product name')
      end

      it 'has every necessary product attribute' do
        expect(products_with_sales.first)
          .to have_attributes(price: 1000, active: true)
      end
    end

    context 'user with 1 products with 1 settled and 1 unsettled invoices' do
      let(:products_with_sales) { user_with_product.products_with_sales }
      before do
        create(:invoice_product, user_product: user_with_product.user_products.first)
        create(:invoice_product,
          user_product: user_with_product.user_products.first,
          invoice_settled: false)
      end

      it 'returns array with 1 element' do
        expect(products_with_sales.length).to eq(1)
      end

      it 'has attribute total_satoshi with correct value' do
        expect(products_with_sales.first.total_satoshi).to eq(100000)
      end

      it 'has attribute total_count with correct value' do
        expect(products_with_sales.first.total_count).to eq(1)
      end
    end

    context 'user with 1 product and 2 settled invoices' do
      let(:products_with_sales) { user_with_product.products_with_sales }
      before do
        create(:invoice_product, user_product: user_with_product.user_products.first)
        create(:invoice_product, user_product: user_with_product.user_products.first)
      end

      it 'returns array with 1 element' do
        expect(products_with_sales.length).to eq(1)
      end

      it 'has attribute total_satoshi with correct value' do
        expect(products_with_sales.first.total_satoshi).to eq(200000)
      end

      it 'has attribute total_count with correct value' do
        expect(products_with_sales.first.total_count).to eq(2)
      end
    end

    context 'user with 3 products: 1 with no invoice, 1 unsettled and 1 settled' do
      let(:user_with_multiple_products) { create(:user_with_product, product_count: 3) }
      let(:products_with_sales) { user_with_multiple_products.products_with_sales }
      let(:invoice_a) { create(:invoice) }
      let(:invoice_b) { create(:invoice, settled: false) }
      before do
        create(:invoice_product,
          invoice: invoice_a,
          user_product: user_with_multiple_products.user_products.first)
        create(:invoice_product,
          invoice: invoice_b,
          user_product: user_with_multiple_products.user_products.second)
      end

      it 'considers the three products' do
        expect(products_with_sales.length).to eq(3)
      end
    end
  end
end
