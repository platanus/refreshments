require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of(:clp) }
    it { should validate_presence_of(:memo) }
    it { should validate_presence_of(:payment_request) }
    it { should validate_presence_of(:r_hash) }
    it { should validate_presence_of(:satoshis) }
  end
end
