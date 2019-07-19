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
      let(:ledger_account) { create(:ledger_account, balance: 5000) }

      before do
        allow(user).to receive(:available_funds).and_return(ledger_account)
      end

      before do
        mock_authentication
      end

      it 'assigns correct ledger account' do
        get :index
        expect(assigns(:ledger_account)).to be(ledger_account)
      end

      it 'assigns correct total balance' do
        get :index
        expect(assigns(:total_balance)).to eq(ledger_account.balance)
      end
    end
  end
end
