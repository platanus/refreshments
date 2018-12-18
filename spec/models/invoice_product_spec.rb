require 'rails_helper'

RSpec.describe InvoiceProduct, type: :model do
  describe "validations" do
    it { should belong_to(:product) }
    it { should belong_to(:invoice) }
  end
end
