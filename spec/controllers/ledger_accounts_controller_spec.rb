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
      before do
        create_list(:ledger_line, 7, ledger_account: ledger_account)
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

      it 'returns correct "index" view' do
        get :index
        expect(response).to render_template('ledger_accounts/index')
      end
    end
  end
end
