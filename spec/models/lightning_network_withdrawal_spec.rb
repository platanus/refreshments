require 'rails_helper'
require 'aasm/rspec'

RSpec.describe LightningNetworkWithdrawal, type: :model do
  it 'has a valid factory' do
    lnw = build(:lightning_network_withdrawal)
    expect(lnw).to be_valid
  end

  it 'changes state from pending to confirmed' do
    expect(subject).to transition_from(:pending).to(:confirmed).on_event(:confirm)
  end

  it 'changes state from pending to rejected' do
    expect(subject).to transition_from(:pending).to(:rejected).on_event(:reject)
  end
end
