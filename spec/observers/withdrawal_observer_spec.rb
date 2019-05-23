require 'rails_helper'

describe WithdrawalObserver do
  def trigger(_type, _event)
    described_class.trigger(_type, _event, withdrawal)
  end

  let(:user_with_invoice) { create(:user_with_invoice) }
  let(:withdrawal) { build(:withdrawal, user: user_with_invoice, aasm_state: 'confirmed') }

  before do
    allow(RegisterWithdrawalPayment).to receive(:for).with(withdrawal: withdrawal)
  end

  context "when withdrawal is save" do
    it do
      trigger(:after, :save)
      expect(RegisterWithdrawalPayment).to have_received(:for).with(withdrawal: withdrawal)
    end
  end

  context "when invoice is not save" do
    it do
      trigger(:before, :save)
      expect(RegisterWithdrawalPayment).to_not have_received(:for)
    end
  end
end
