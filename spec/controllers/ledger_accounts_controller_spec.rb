require 'rails_helper'

RSpec.describe LedgerAccountsController, type: :controller do
  describe 'GET #index' do
    context 'unauthenticated user' do
      it 'redirects to sign up form' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'authenticated user' do
      let(:user) { create(:user) }
      let!(:ledger_account) { create(:ledger_account, accountable: user, id: 123) }
      let!(:first_ledger_line) do
        create(:ledger_line, id: 1, ledger_account: ledger_account, accountable: invoice_product)
      end
      let!(:account_ledger_lines) { create_list(:ledger_line, 6, ledger_account: ledger_account) }
      let!(:product) { create(:product, id: 147, name: 'Coca Cola') }
      let!(:user_product) do
        create(:user_product, id: 159, user: user, product: product, price: 1234)
      end
      let!(:invoice_product) { create(:invoice_product, id: 456, user_product: user_product) }

      before do
        mock_authentication
      end

      it 'assigns correct ledger account' do
        get :index
        expect(assigns(:ledger_account).id).to be(123)
      end

      it 'assigns list with ledger lines' do
        get :index
        expect(assigns(:ledger_lines).length).to eq(7)
      end

      it 'assigns correct total balance' do
        get :index
        expect(assigns(:total_balance)).to eq(account_ledger_lines.last.balance)
      end

      it 'assigns product data with correct attributes' do
        get :index
        expect(assigns(:line_id_to_product_data_hash)[1]).to eq(['Coca Cola', 1234])
      end

      it 'returns correct "index" view' do
        get :index
        expect(response).to render_template('ledger_accounts/index')
      end
    end
  end
end
