require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  def mock_post_request(name, image)
    params = { product: { name: name } }
    params[:product][:image] = image unless image.nil?
    post :create, params: params
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

      context 'with product name and image' do
        before { mock_post_request('test_product', image) }

        it 'creates a product in database' do
          expect(Product.all.count).to eq(1)
        end

        it 'creates product with correct name' do
          expect(assigns(:product)).to have_attributes(name: 'test_product')
        end

        it 'uploads image correctly' do
          expect(assigns(:product).image).to be_attached
        end

        it 'redirects to new user product form' do
          expect(response).to redirect_to(new_user_product_path)
        end
      end

      context 'with no name' do
        before { mock_post_request(nil, image) }

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

      context 'with no image' do
        before { mock_post_request('test_name', nil) }

        it 'does not create product' do
          expect(Product.all.count).to eq(0)
        end

        it 'returns "new" view' do
          expect(response).to render_template('products/new')
        end

        it 'sets image error attribute to product' do
          expect(assigns(:product).errors.messages[:image]).to include('no puede estar en blanco')
        end
      end
    end
  end
end
