require 'rails_helper'

describe WithdrawalObserver do
  def trigger(_type, _event)
    described_class.trigger(_type, _event, withdrawal)
  end

  let(:user_with_account) { create(:user, :with_account) }
  let(:withdrawal) do
    build(:withdrawal, id: 123, user: user_with_account, aasm_state: 'confirmed')
  end

  context 'when withdrawal is saved' do
    it do
      trigger(:after, :save)
      expect { RegisterWithdrawalPaymentJob.to receive(:perform_later).with(withdrawal) }
    end
  end

  context 'when withdrawal is not saved' do
    it do
      trigger(:before, :save)
      expect { RegisterWithdrawalPaymentJob.to_not receive(:perform_later) }
    end
  end
end
