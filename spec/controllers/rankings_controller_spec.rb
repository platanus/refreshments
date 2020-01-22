require 'rails_helper'

RSpec.describe RankingsController, type: :controller do
  describe "GET #index" do
    let(:ledger_account) { create(:user_ledger_account) }

    before do
      allow(ENV).to receive(:fetch)
        .with('BUSINESS_USER_ID').and_return(ledger_account.accountable_id)
    end

    it 'returns correct "index" view'  do
      get :index
      expect(response).to render_template('rankings/index')
    end
  end
end
