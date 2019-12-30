require 'rails_helper'

RSpec.describe Api::V1::SentryController do
  it "raise user's payment didn't work" do
    get :notify_payment_error
    expect(response).to have_http_status(:error)
  end
end
