require 'rails_helper'

RSpec.describe Wallet, type: :model do
  it "has a valid factory" do
    wallet = build(:wallet)
    expect(wallet).to be_valid
  end
end
