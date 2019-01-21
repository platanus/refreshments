require 'rails_helper'

RSpec.describe UserProductsController, type: :controller do
  def mock_post_request(product_id, price, stock)
    post :create, params: {
      user_product: {
        product_id: product_id,
        price: price,
        stock: stock
      }
    }
  end

  describe 'GET #index' do
    context 'unauthenticated user' do
      it 'redirects to sign up form' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'authenticated user' do
      let(:user) { create(:user) }
      before do
        create_list(:user_product, 3, user: user)
        mock_authentication
      end

      it 'assigns list with user products' do
        get :index
        expect(assigns(:user_products).length).to eq(3)
      end

      it 'assigns user withdrawable amount' do
        get :index
        expect(assigns(:withdrawable_amount)).to be_an(Integer)
      end

      it 'returns correct "index" view' do
        get :index
        expect(response).to render_template('user_products/index')
      end
    end
  end

  describe 'GET #new' do
    context 'unauthenticated user' do
      it 'redirects to sign up form' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'authenticated user' do
      let(:user) { create(:user) }
      before { mock_authentication }

      it 'builds new user product' do
        get :new
        expect(assigns(:user_product)).to be_a_new(UserProduct)
      end

      it 'returns correct "new" view' do
        get :new
        expect(response).to render_template('user_products/new')
      end

      it 'does not create a user product in data base' do
        get :new
        expect(UserProduct.all.count).to eq(0)
      end
    end
  end

  describe 'POST #create' do
    context 'unauthenticated user' do
      it 'redirects to sign up form' do
        post :create
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'authenticated user' do
      let(:user) { create(:user) }
      let(:product) { create(:product) }
      before { mock_authentication }

      context 'with product_id, price and stock' do
        before { mock_post_request(product.id, 100, 10) }

        it 'creates a user product in database' do
          expect(UserProduct.all.count).to eq(1)
        end

        it 'creates user product with correct product' do
          expect(assigns(:user_product).product).to have_attributes(id: product.id)
        end

        it 'creates user product with correct price' do
          expect(assigns(:user_product)).to have_attributes(price: 100)
        end

        it 'creates user product with correct price' do
          expect(assigns(:user_product)).to have_attributes(stock: 10)
        end
      end

      context 'with no product' do
        before { mock_post_request(nil, 100, 10) }

        it 'does not create user product' do
          expect(UserProduct.all.count).to eq(0)
        end

        it 'returns "new" view' do
          expect(response).to render_template('user_products/new')
        end

        it 'sets product error attribute to user product' do
          expect(assigns(:user_product).errors.messages[:product])
            .to include('debe existir')
        end
      end

      context 'with no price' do
        before { mock_post_request(product.id, nil, 10) }

        it 'does not create user product' do
          expect(UserProduct.all.count).to eq(0)
        end

        it 'returns "new" view' do
          expect(response).to render_template('user_products/new')
        end

        it 'sets price error attribute to user product' do
          expect(assigns(:user_product).errors.messages[:price])
            .to include('no puede estar en blanco')
        end
      end

      context 'with no stock' do
        before { mock_post_request(product.id, 100, nil) }

        it 'does not create product' do
          expect(UserProduct.all.count).to eq(0)
        end

        it 'returns "new" view' do
          expect(response).to render_template('user_products/new')
        end

        it 'sets stock error attribute to user product' do
          expect(assigns(:user_product).errors.messages[:stock])
            .to include('no puede estar en blanco')
        end
      end
    end
  end

  describe 'GET #edit' do
    context 'unauthenticated user' do
      it 'redirects to sign up form' do
        get :edit, params: { id: 5 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'authenticated user' do
      let(:user) { create(:user_with_product) }
      let(:user_product) { user.user_products.first }
      before { mock_authentication }

      context 'user product exists and belongs to user' do
        before { get :edit, params: { id: user_product.id } }

        it { expect(assigns(:user_product)).to be_a(UserProduct) }
        it { expect(assigns(:user_product)).to have_attributes(id: user_product.id) }

        it 'returns correct "edit" view' do
          expect(response).to render_template('user_products/edit')
        end
      end

      context 'user product doesnt exists in users scope' do
        it 'returns 404 error' do
          expect { get(:edit, params: { id: 100 }) }
            .to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe 'PATCH #update' do
    context 'unauthenticated user' do
      it 'redirects to sign up form' do
        patch :update, params: { id: 5 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'authenticated user' do
      let(:user) { create(:user_with_product) }
      let(:user_product) { user.user_products.first }
      before { mock_authentication }

      context 'user product exists and belongs to user' do
        before do
          patch :update, params: {
            id: user_product.id,
            user_product: {
              price: 10000,
              active: false,
              stock: 20
            }
          }
        end

        it { expect(assigns(:user_product)).to be_a(UserProduct) }
        it { expect(assigns(:user_product)).to have_attributes(id: user_product.id) }

        it 'changes price correctly' do
          expect(user_product.reload).to have_attributes(price: 10000)
        end

        it 'changes active correctly' do
          expect(user_product.reload).to have_attributes(active: false)
        end

        it 'changes stock correctly' do
          expect(user_product.reload).to have_attributes(stock: 20)
        end
      end

      context 'product doesnt exists in users scope' do
        it 'returns 404 error' do
          expect { patch(:update, params: { id: 100 }) }
            .to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'unauthenticated user' do
      it 'redirects to sign up form' do
        delete :destroy, params: { id: 5 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'authenticated user' do
      let(:user) { create(:user_with_product, product_count: 2) }
      let(:product_to_delete) { user.user_products.first }
      before { mock_authentication }

      it 'deletes correct product' do
        expect(UserProduct.find_by(id: product_to_delete.id)).not_to be(nil)
        delete :destroy, params: { id: product_to_delete.id }
        expect(UserProduct.find_by(id: product_to_delete.id)).to be(nil)
      end

      it 'deletes only one product' do
        expect { delete :destroy, params: { id: product_to_delete.id } }
          .to change(UserProduct, :count).by(-1)
      end
    end
  end
end
