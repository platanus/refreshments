require 'rails_helper'

def mock_authentication
  allow(controller).to receive(:current_user).and_return(user)
  allow(request.env['warden']).to receive(:authenticate!).and_return(user)
end

def mock_post_request(name, price, image)
  params = { product: { name: name, price: price } }
  params[:product][:image] = image unless image.nil?
  post :create, params: params
end

RSpec.describe ProductsController, type: :controller do
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
        create_list(:product, 3, user: user)
        mock_authentication
      end

      it 'assigns list with user products' do
        get :index
        expect(assigns(:products)).to have(3).items
      end

      it 'returns correct "index" view' do
        get :index
        expect(response).to render_template('products/index')
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

      it 'builds new product' do
        get :new
        expect(assigns(:product)).to be_a_new(Product)
      end

      it 'returns correct "new" view' do
        get :new
        expect(response).to render_template('products/new')
      end

      it 'does not create a product in data base' do
        get :new
        expect(Product.all.count).to eq(0)
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
      before { mock_authentication }

      context 'with product name, price' do
        before { mock_post_request('test_product', 100, nil) }

        it 'creates a product in database' do
          expect(Product.all.count).to eq(1)
        end

        it 'creates product with correct name' do
          expect(assigns(:product)).to have_attributes(name: 'test_product')
        end

        it 'creates product with correct price' do
          expect(assigns(:product)).to have_attributes(price: 100)
        end
      end

      context 'with no name' do
        before { mock_post_request(nil, 100, nil) }

        it 'does not create product' do
          expect(Product.all.count).to eq(0)
        end

        it 'returns "new" view' do
          expect(response).to render_template('products/new')
        end

        it 'sets name error attribute to product' do
          expect(assigns(:product).errors.messages[:name]).to include('no puede estar en blanco')
        end
      end

      context 'with no price' do
        before { mock_post_request('test_name', nil, nil) }

        it 'does not create product' do
          expect(Product.all.count).to eq(0)
        end

        it 'returns "new" view' do
          expect(response).to render_template('products/new')
        end

        it 'sets name error attribute to product' do
          expect(assigns(:product).errors.messages[:price]).to include('no puede estar en blanco')
        end
      end

      context 'with image' do
        let(:image) do
          fixture_file_upload(
            Rails.root.join('spec', 'support', 'assets', 'beverage.jpeg'),
            'image/jpg'
          )
        end
        before { mock_post_request('test_name', 100, image) }

        it 'uploads image correctly' do
          expect(assigns(:product).image).to be_attached
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
      let(:user) { create(:user) }
      before { mock_authentication }

      context 'product exists and belongs to user' do
        let(:product) { create(:product, user: user) }
        before { get :edit, params: { id: product.id } }

        it { expect(assigns(:product)).to be_a(Product) }
        it { expect(assigns(:product)).to have_attributes(id: product.id) }

        it 'returns correct "edit" view' do
          expect(response).to render_template('products/edit')
        end
      end

      context 'product doesnt exists in users scope' do
        it 'returns 404 error' do
          expect { get(:edit, params: { id: 5 }) }.to raise_error(ActiveRecord::RecordNotFound)
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
      let(:user) { create(:user) }
      before { mock_authentication }

      context 'product exists and belongs to user' do
        let(:product) { create(:product, user: user) }
        before do
          patch :update, params: {
            id: product.id,
            product: {
              name: 'new_test_name',
              price: 500,
              active: false
            }
          }
        end

        it { expect(assigns(:product)).to be_a(Product) }
        it { expect(assigns(:product)).to have_attributes(id: product.id) }

        it 'changes name correctly' do
          expect(product.reload).to have_attributes(name: 'new_test_name')
        end

        it 'changes price correctly' do
          expect(product.reload).to have_attributes(price: 500)
        end

        it 'changes active correctly' do
          expect(product.reload).to have_attributes(active: false)
        end
      end

      context 'product doesnt exists in users scope' do
        it 'returns 404 error' do
          expect { patch(:update, params: { id: 5 }) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
