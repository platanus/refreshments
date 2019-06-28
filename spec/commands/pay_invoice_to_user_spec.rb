require 'rails_helper'

describe PayInvoiceToUser do
  def perform(*_args)
    described_class.for(*_args)
  end

  let(:user) { create(:user) }
  let(:invoice_hash) { 'ittCgcRP1G7QGdzTWJ1cn6cZ89R7TfAh' }

  it do
    expect { perform(user: user, invoice_hash: invoice_hash) }
      .to change { LightningNetworkWithdrawal.all.count }.by(1)
  end
end
