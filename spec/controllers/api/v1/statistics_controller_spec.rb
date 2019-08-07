require 'rails_helper'

RSpec.describe Api::V1::StatisticsController, type: :controller do
  describe "GET #fee_balance" do
    before do
      allow(GetFeeBalance).to receive(:for).and_return(145000)
    end

    it 'calls GetFeeBalance command' do
      get :fee_balance
      expect(GetFeeBalance).to have_received(:for)
    end
  end
end
