require 'rails_helper'

RSpec.describe Withdrawal, type: :model do
  it { should validate_presence_of(:amount) }
  it { should belong_to(:user) }

  it 'starts with default "pending" state' do
    withdrawal = create(:withdrawal)
    expect(withdrawal.aasm.current_state).to eq(:pending)
  end
end
