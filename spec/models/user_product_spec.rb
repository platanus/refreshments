require 'rails_helper'

RSpec.describe UserProduct, type: :model do
  describe 'basic validations' do
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:stock) }
    it { should validate_numericality_of(:price) }
    it { should validate_numericality_of(:stock) }
    it { should have_many(:invoice_products) }
    it { should have_many(:invoices) }
    it { should belong_to(:user) }
    it { should belong_to(:product) }
  end
end
