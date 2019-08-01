require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  def mock_post_request(name, price, stock, image, category)
    params = {
      product: {
        name: name,
        price: price,
        stock: stock,
        category: category
      }
    }
    params[:product][:image] = image unless image.nil?
    post :create, params: params
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
        create_list(:product, 3, user: user)
        allow(user).to receive(:withdrawable_amount).and_return(20)
        mock_authentication
      end

      it 'assigns list with products' do
        get :index
        expect(assigns(:products).length).to eq(3)
      end

      it 'assigns correct withdrawable amount' do
        get :index
        expect(assigns(:withdrawable_amount)).to eq(20)
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
      let(:image) do
        fixture_file_upload(
          Rails.root.join('spec', 'support', 'assets', 'beverage.jpeg'),
          'image/jpg'
        )
      end
      before { mock_authentication }

      context 'with correct params' do
        before { mock_post_request('test_name', 100, 10, image, :drinks) }

        it 'creates product with correct name' do
          expect(assigns(:product)).to have_attributes(name: 'test_name')
        end

        it 'creates product with correct price' do
          expect(assigns(:product)).to have_attributes(price: 100)
        end

        it 'creates product with correct stock' do
          expect(assigns(:product)).to have_attributes(stock: 10)
        end

        it 'uploads image correctly' do
          expect(assigns(:product).image).to be_attached
        end

        it 'creates product with correct category' do
          expect(assigns(:product)).to have_attributes(category: 'drinks')
        end

        it 'redirects to product path' do
          expect(response).to redirect_to(user_products_path)
        end
      end

      context 'with no name' do
        before { mock_post_request(nil, 100, 10, image, :drinks) }

        it 'does not create product' do
          expect(Product.all.count).to eq(0)
        end

        it 'returns "new" view' do
          expect(response).to render_template('products/new')
        end

        it 'sets name error attribute to product' do
          expect(assigns(:product).errors.messages[:name])
            .to include('no puede estar en blanco')
        end
      end

      context 'with no price' do
        before { mock_post_request('test_name', nil, 10, image, :drinks) }

        it 'does not create product' do
          expect(Product.all.count).to eq(0)
        end

        it 'returns "new" view' do
          expect(response).to render_template('products/new')
        end

        it 'sets price error attribute to product' do
          expect(assigns(:product).errors.messages[:price])
            .to include('no puede estar en blanco')
        end
      end

      context 'with no stock' do
        before { mock_post_request('test_name', 100, nil, image, :drinks) }

        it 'does not create product' do
          expect(Product.all.count).to eq(0)
        end

        it 'returns "new" view' do
          expect(response).to render_template('products/new')
        end

        it 'sets stock error attribute to product' do
          expect(assigns(:product).errors.messages[:stock])
            .to include('no puede estar en blanco')
        end
      end

      context 'with no image' do
        before { mock_post_request('test_name', 100, 10, nil, :drinks) }

        it 'does not create product' do
          expect(Product.all.count).to eq(0)
        end

        it 'returns "new" view' do
          expect(response).to render_template('products/new')
        end

        it 'sets image error attribute to product' do
          expect(assigns(:product).errors.messages[:image])
            .to include('no puede estar en blanco')
        end
      end

      context 'with no category' do
        before { mock_post_request('test_name', 100, 10, image, nil) }

        it 'does not create product' do
          expect(Product.all.count).to eq(0)
        end

        it 'returns "new" view' do
          expect(response).to render_template('products/new')
        end

        it 'sets category error attribute to product' do
          expect(assigns(:product).errors.messages[:category])
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
      let(:product) { user.products.first }
      before { mock_authentication }

      context 'product exists and belongs to user' do
        before { get :edit, params: { id: product.id } }

        it { expect(assigns(:product)).to be_a(Product) }
        it { expect(assigns(:product)).to have_attributes(id: product.id) }

        it 'returns correct "edit" view' do
          expect(response).to render_template('products/edit')
        end
      end

      context 'product doesnt exists in users scope' do
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
      let(:product) { user.products.first }
      before { mock_authentication }

      context 'product exists and belongs to user' do
        before do
          patch :update, params: {
            id: product.id,
            product: {
              name: 'test_name',
              price: 10000,
              active: false,
              stock: 20,
              category: :other
            }
          }
        end

        it { expect(assigns(:product)).to be_a(Product) }
        it { expect(assigns(:product)).to have_attributes(id: product.id) }

        it 'changes name correctly' do
          expect(product.reload).to have_attributes(name: 'test_name')
        end

        it 'changes price correctly' do
          expect(product.reload).to have_attributes(price: 10000)
        end

        it 'changes active correctly' do
          expect(product.reload).to have_attributes(active: false)
        end

        it 'changes stock correctly' do
          expect(product.reload).to have_attributes(stock: 20)
        end
        it 'changes category correctly' do
          expect(product.reload).to have_attributes(category: 'other')
        end
      end

      context 'product doesnt exists in users scope' do
        it 'returns 404 error' do
          expect { patch(:update, params: { id: 1000 }) }
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
      let(:product_to_delete) { user.products.first }
      before { mock_authentication }

      it 'deletes correct product' do
        expect(Product.find_by(id: product_to_delete.id).active).to be(true)
        delete :destroy, params: { id: product_to_delete.id }
        expect(Product.find_by(id: product_to_delete.id).active).to be(false)
      end

      it 'does not delete product from DB' do
        expect { delete :destroy, params: { id: product_to_delete.id } }
          .to change(Product, :count).by(0)
      end
    end
  end
end
