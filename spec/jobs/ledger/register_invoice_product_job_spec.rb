require 'rails_helper'

RSpec.describe Ledger::RegisterInvoiceProductJob, type: :job do
  let(:invoice_product) { create(:invoice_product) }
  let(:ledger_register) { double("register", perform: {}) }

  def perform
    described_class.perform_now(invoice_product)
  end

  it 'calls ledger RegisterInvoiceProduct command with invoice_product param' do
    expect(Ledger::RegisterInvoiceProduct).to receive(:new).with(invoice_product)
                                                           .and_return(ledger_register)
    perform
  end
end
