require 'rails_helper'

def mock_authentication
  allow(controller).to receive(:current_user).and_return(user)
  allow(request.env['warden']).to receive(:authenticate!).and_return(user)
end

def mock_post_request(name, price)
  post :create, params: { product: { name: name, price: price } }
end

RSpec.describe ProductsController, type: :controller do
  describe "GET #index" do
    context "unauthenticated user" do

      it "redirects to sign up form" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "authenticated user" do
      let(:user) { create(:user, name: "test_user", email: "test@email.com", password: "123456") }
      before do
        create_list(:product, 3, user: user)
        mock_authentication
      end

      it "assigns list with user products" do
        get :index
        expect(assigns(:products)).to have(3).items
      end

      it "returns correct 'index' view" do
        get :index
        expect(response).to render_template('products/index')
      end
    end
  end

  describe "GET #new" do
    context "unauthenticated user" do

      it "redirects to sign up form" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "authenticated user" do
      let(:user) { create(:user, name: "test_user", email: "test@email.com", password: "123456") }
      before { mock_authentication }

      it "builds new product" do
        get :new
        expect(assigns(:product)).to be_a_new(Product)
      end

      it "returns correct 'new' view" do
        get :new
        expect(response).to render_template('products/new')
      end

      it "does not create a product in data base" do
        get :new
        expect(Product.all.count).to eq(0)
      end
    end
  end

  describe "POST #create" do
    context "unauthenticated user" do

      it "redirects to sign up form" do
        post :create
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "authenticated user" do
      let(:user) { create(:user, name: "test_user", email: "test@email.com", password: "123456") }
      before { mock_authentication }

      context "with product name, price" do
        before { mock_post_request("test_product", 100) }

        it "creates a product in database" do
          expect(Product.all.count).to eq(1)
        end

        it "creates product with correct name" do
          expect(assigns(:product)).to have_attributes(name: "test_product")
        end

        it "creates product with correct price" do
          expect(assigns(:product)).to have_attributes(price: 100)
        end
      end

      context "with no name" do
        before { mock_post_request(nil, 100) }

        it "does not create product" do
          expect(Product.all.count).to eq(0)
        end

        it "returns 'new' view" do
          expect(response).to render_template('products/new')
        end

        it "sets name error attribute to product" do
          expect(assigns(:product).errors.messages[:name]).to include("no puede estar en blanco")
        end
      end

      context "with no price" do
        before { mock_post_request("test_name", nil) }

        it "does not create product" do
          expect(Product.all.count).to eq(0)
        end

        it "returns 'new' view" do
          expect(response).to render_template('products/new')
        end

        it "sets name error attribute to product" do
          expect(assigns(:product).errors.messages[:price]).to include("no puede estar en blanco")
        end
      end
    end
  end
end
