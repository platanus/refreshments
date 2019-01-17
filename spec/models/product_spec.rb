require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'basic validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:image) }
    it { should have_many(:user_products) }
    it { should have_many(:users) }
    it { should have_many(:invoice_products) }
    it { should have_many(:invoices) }
  end
end
