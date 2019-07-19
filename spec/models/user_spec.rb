require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user, :with_account) }
  let(:invoice_product) { create(:invoice_product) }
  let(:user_with_product) { create(:user_with_product) }
  let(:user_with_invoice) { create(:user_with_invoice) }

  before do
    PowerTypes::Observable.observable_disabled = true
  end

  after do
    if PowerTypes::Observable.observable_disabled?
      PowerTypes::Observable.observable_disabled = false
    end
  end

  describe 'basic validations' do
    it { should have_many(:products) }
    it { should have_many(:withdrawals) }
  end

  describe '#total_sales' do
    let(:user) { create(:user) }
    let(:user_ledger_account) { create(:ledger_account, accountable: user) }

    context 'user has no sales' do
      it { expect(user.total_sales).to be(0) }
    end

    context 'user has only sales' do
      before do
        create_list(
          :ledger_line,
          6,
          accountable: invoice_product,
          ledger_account: user_ledger_account,
          amount: -15000
        )
      end
      it { expect(user.total_sales).to be(90000) }
    end

    context 'user has sales and withdrawals' do
      before do
        create_list(
          :ledger_line,
          5,
          accountable: invoice_product,
          ledger_account: user_ledger_account,
          amount: -15000
        )
        create(
          :ledger_line,
          accountable: user,
          ledger_account: user_ledger_account,
          amount: 15000
        )
      end
      it { expect(user.total_sales).to be(75000) }
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
        create(
          :invoice_product,
          user_product: user_with_product.user_products.first,
          invoice_settled: false
        )
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
        create(
          :invoice_product,
          invoice: invoice_a,
          user_product: user_with_multiple_products.user_products.first
        )
        create(
          :invoice_product,
          invoice: invoice_b,
          user_product: user_with_multiple_products.user_products.second
        )
      end

      it 'considers the three products' do
        expect(products_with_sales.length).to eq(3)
      end
    end
  end
end
