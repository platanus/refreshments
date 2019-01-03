require 'rails_helper'

RSpec.describe WithdrawalsController, type: :controller do
  def mock_post_request(amount, btc_address, action)
    params = {
      withdrawal: {
        amount: amount,
        btc_address: btc_address
      }
    }
    post action, params: params, xhr: true
  end

  def create_withdrawals_with_every_state
    create_withdrawal_without_after_commit_callback
    create_withdrawal_without_after_commit_callback.confirm!
    create_withdrawal_without_after_commit_callback.reject!
  end

  let(:btc_address) { '1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i' }

  describe 'GET #index' do
    let(:user) { create_user_with_invoice(10000, 10000, 500000) }

    context 'unauthenticated user' do
      it 'redirects to sign up form' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'authenticated user' do
      before do
        create_withdrawals_with_every_state
        mock_authentication
      end

      it 'assigns list with user withdrawals' do
        get :index
        expect(assigns(:withdrawals)).to have(3).items
      end

      it 'assigns total pending sum' do
        get :index
        expect(assigns(:total_pending)).to be_an(Integer)
      end

      it 'assigns total confirmed sum' do
        get :index
        expect(assigns(:total_confirmed)).to be_an(Integer)
      end

      it 'returns correct "index" view' do
        get :index
        expect(response).to render_template('withdrawals/index')
      end
    end
  end

  describe 'GET #new' do
    let(:user) { create(:user) }

    context 'unauthenticated user' do
      it 'returns 401 unauthorized' do
        get :new, xhr: true
        expect(response).to have_http_status(401)
      end
    end

    context 'authenticated user' do
      before { mock_authentication }

      it 'builds new withdrawal' do
        get :new, xhr: true
        expect(assigns(:withdrawal)).to be_a_new(Withdrawal)
      end

      it 'returns correct "new" view' do
        get :new, xhr: true
        expect(response).to render_template('withdrawals/new')
      end

      it 'does not create a withdrawal in data base' do
        get :new, xhr: true
        expect(Withdrawal.all.count).to eq(0)
      end

      it 'returns a JS file' do
        get :new, xhr: true
        expect(response.content_type).to eq('text/javascript')
      end
    end
  end

  describe 'POST #create' do
    let(:action) { :create }
    let(:user) { create_user_with_invoice(10000, 10000, 500000) }
    before do
      allow_any_instance_of(Withdrawal)
        .to receive(:add_job_to_withdrawal_requests_worker)
        .and_return(true)
    end

    context 'unauthenticated user' do
      it 'returns 401 unauthorized' do
        post action, xhr: true
        expect(response).to have_http_status(401)
      end
    end

    context 'authenticated user' do
      before { mock_authentication }

      context 'with amount and valid btc address' do
        before { mock_post_request(10000, btc_address, action) }

        it 'creates a withdrawal in database' do
          expect(Withdrawal.all.count).to eq(1)
        end

        it 'creates withdrawal with correct amount' do
          expect(assigns(:withdrawal)).to have_attributes(amount: 10000)
        end

        it 'creates withdrawal with correct btc_address' do
          expect(assigns(:withdrawal)).to have_attributes(btc_address: btc_address)
        end

        it 'response is a JS file' do
          expect(response.content_type).to eq('text/javascript')
        end

        it 'returns correct JS file' do
          expect(response).to render_template('withdrawals/create')
        end
      end

      context 'with invalid amount' do
        before { mock_post_request(nil, btc_address, action) }

        it 'does not create withdrawal' do
          expect(Withdrawal.all.count).to eq(0)
        end

        it 'returns "new" view' do
          expect(response).to render_template('withdrawals/new')
        end

        it 'sets amount error attribute to withdrawal' do
          expect(assigns(:withdrawal).errors.messages[:amount].length).to be > 0
        end

        it 'response is a JS file' do
          expect(response.content_type).to eq('text/javascript')
        end
      end

      context 'with invalid btc_addres' do
        before { mock_post_request(10000, nil, action) }

        it 'does not create withdrawal' do
          expect(Withdrawal.all.count).to eq(0)
        end

        it 'returns "new" view' do
          expect(response).to render_template('withdrawals/new')
        end

        it 'sets btc address error attribute to withdrawal' do
          expect(assigns(:withdrawal).errors.messages[:btc_address].length).to be > 0
        end

        it 'response is a JS file' do
          expect(response.content_type).to eq('text/javascript')
        end
      end
    end
  end

  describe 'POST #validate' do
    let(:action) { :validate }
    let(:user) { create_user_with_invoice(10000, 10000, 500000) }

    context 'unauthenticated user' do
      it 'returns 401 unauthorized' do
        post action, xhr: true
        expect(response).to have_http_status(401)
      end
    end

    context 'authenticated user' do
      before { mock_authentication }

      context 'with amount and valid btc address' do
        before { mock_post_request(10000, btc_address, action) }

        it 'response is a JS file' do
          expect(response.content_type).to eq('text/javascript')
        end

        it 'returns correct JS file' do
          expect(response).to render_template('withdrawals/confirm')
        end
      end

      context 'with invalid amount' do
        before { mock_post_request(nil, btc_address, action) }

        it 'returns "new" view' do
          expect(response).to render_template('withdrawals/new')
        end

        it 'sets amount error attribute to withdrawal' do
          expect(assigns(:withdrawal).errors.messages[:amount].length).to be > 0
        end

        it 'response is a JS file' do
          expect(response.content_type).to eq('text/javascript')
        end
      end

      context 'with invalid btc_addres' do
        before { mock_post_request(10000, nil, action) }

        it 'returns "new" view' do
          expect(response).to render_template('withdrawals/new')
        end

        it 'sets btc address error attribute to withdrawal' do
          expect(assigns(:withdrawal).errors.messages[:btc_address].length).to be > 0
        end

        it 'response is a JS file' do
          expect(response.content_type).to eq('text/javascript')
        end
      end
    end
  end
end