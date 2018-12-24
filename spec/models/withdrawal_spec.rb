require 'rails_helper'

RSpec.describe Withdrawal, type: :model do
  it { should validate_presence_of(:amount) }
  it { should belong_to(:user) }
  let(:withdrawal) { create(:withdrawal) }

  it 'starts with default "pending" state' do
    expect(withdrawal.aasm.current_state).to eq(:pending)
  end

  it 'changes state to "confirmed" correctly' do
    withdrawal.confirm
    expect(withdrawal.aasm.current_state).to eq(:confirmed)
  end
end
