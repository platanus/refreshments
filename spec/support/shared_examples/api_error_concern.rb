shared_examples "exception_handler_controller" do
  context "with missing required parameter" do
    controller do
      def index
        params.require(:missing_param)
      end
    end

    it "responds 400" do
      get :index, format: :json
      expect(response).to have_http_status(:bad_request)
    end
  end

  context "when controller raises ActiveRecord::RecordNotFound" do
    controller do
      def index
        raise ActiveRecord::RecordNotFound
      end
    end

    it "responds 404" do
      get :index, format: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  context "when controller raises ActiveRecord::RecordInvalid" do
    controller do
      class InvalidRecord
        include ActiveModel::Model
      end

      def index
        raise ActiveRecord::RecordInvalid.new(InvalidRecord.new)
      end
    end

    it "responds 400" do
      get :index, format: :json
      expect(response).to have_http_status(:bad_request)
    end
  end
end
