require 'rails_helper'

describe Api::V1::SlackController, type: :controller do
  describe 'GET #get_users' do
    it "returns http success" do
      get :get_users
      expect(response).to have_http_status(:success)
    end
    it "returns array of slack users" do
      get :get_users
      expect(JSON.parse(response.body).keys).to contain_exactly("slack")
    end
  end
end
