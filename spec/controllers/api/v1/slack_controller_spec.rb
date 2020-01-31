require 'rails_helper'

describe Api::V1::SlackController, type: :controller do
  describe 'GET #get_users' do
    let(:slack) { instance_double('SlackService') }
    let(:slack_user) do
      double(
        deleted: true,
        profile: {
          display_name_normalized: "bla",
          id: "U"
        }
      )
    end

    before do
      allow(SlackService).to receive(:new).and_return(slack)
      allow(slack).to receive(:get_slack_users).and_return([slack_user])
      allow(slack).to receive(:notify_user).and_return(:success)
    end

    it "returns http success" do
      get :get_users
      expect(response).to have_http_status(:success)
    end
    it "returns array of slack users" do
      get :get_users
      expect(JSON.parse(response.body).keys).to contain_exactly("slack")
    end
    it "notifies user" do
      post :notify_user, params: {
        user_name: slack_user.profile["display_name_normalized"],
        user_id: slack_user.profile["id"]
      }
      expect(response).to have_http_status(:success)
    end
  end
end
