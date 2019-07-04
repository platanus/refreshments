require 'rails_helper'

RSpec.describe LightningNetworkWithdrawalsController, type: :controller do
  def mock_post_request(invoice_hash, action)
    params = {
      lightning_network_withdrawal: {
        invoice_hash: invoice_hash
      }
    }
    post action, params: params, xhr: true
  end

  let(:user) { create(:user) }

  describe 'GET #new' do
    context 'unauthenticated user' do
      it 'returns 401 unauthorized' do
        get :new, xhr: true
        expect(response).to have_http_status(401)
      end
    end

    context 'authenticated user' do
      before { mock_authentication }

      it 'builds new lightning_network_withdrawal' do
        get :new, xhr: true
        expect(assigns(:lightning_network_withdrawal)).to be_a_new(LightningNetworkWithdrawal)
      end

      it 'returns correct "new" view' do
        get :new, xhr: true
        expect(response).to render_template('lightning_network_withdrawals/new')
      end

      it 'does not create a lightning_network_withdrawal in data base' do
        get :new, xhr: true
        expect(LightningNetworkWithdrawal.all.count).to eq(0)
      end

      it 'returns a JS file' do
        get :new, xhr: true
        expect(response.content_type).to eq('text/javascript')
      end
    end
  end

  describe 'POST #create' do
    let(:invoice_hash) { 'invoice hash' }
    let(:action) { :create }

    context 'when no error is raised' do
      before do
        mock_authentication
        expect(PayInvoiceToUser).to receive(:for)
          .with(invoice_hash: invoice_hash, user: user)
          .and_return(true)
      end

      it 'renders successful template' do
        mock_post_request(invoice_hash, action)
        expect(subject).to render_template('successful')
      end
    end

    context 'when lightning network client error is raised' do
      before do
        mock_authentication
        expect(PayInvoiceToUser).to receive(:for)
          .with(invoice_hash: invoice_hash, user: user)
          .and_raise(LightningNetworkClientError::ClientError)
      end

      it 'renders unsuccessful template' do
        mock_post_request(invoice_hash, action)
        expect(subject).to render_template('unsuccessful')
      end
    end
  end
end
