require 'rails_helper'

RSpec.describe DebtProduct, type: :model do
  it 'has a valid factory' do
    expect(build(:debt_product)).to be_valid
  end

  it { is_expected.to belong_to(:product) }

  describe 'Validations' do
    it { is_expected.to validate_presence_of :debtor }
    it { is_expected.to validate_presence_of :product_price }
  end
end
