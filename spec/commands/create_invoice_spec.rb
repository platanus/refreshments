require 'rails_helper'

describe CreateInvoice do
  let(:product_a) { create(:product) }
  let(:product_b) { create(:product) }

  let(:lightning_network_client) do
    mocked_lightning_client = double
    allow(mocked_lightning_client)
      .to receive(:create_invoice)
      .and_return(
        'r_hash' => 'r_hash',
        'payment_request' => 'payment_request',
        'add_index' => 'add_index'
      )
    mocked_lightning_client
  end

  let(:memo) { 'Memo' }

  let(:products_hash) do
    {
      product_a.id => { 'amount' => 3, 'price' => 1000 },
      product_b.id => { 'amount' => 2, 'price' => 1000 }
    }
  end

  let(:prices_hash) { { product_a.id => 1000, product_b.id => 1000 } }

  def perform
    described_class.for(memo: memo, products_hash: products_hash)
  end

  def mock_lightning_network_client
    allow_any_instance_of(described_class)
      .to receive(:lightning_network_client)
      .and_return(lightning_network_client)
  end

  def mock_price_on_satoshis
    allow(GetPriceOnSatoshis).to receive(:for) do |args|
      args[:clp_price] * 10_000
    end
  end

  def mock_prices_hash
    allow(GetPricesHash)
      .to receive(:for)
      .and_return(prices_hash)
  end

  def mock_create_invoice_products
    allow(CreateInvoiceProducts)
      .to receive(:for)
      .and_return(true)
  end

  before do
    mock_lightning_network_client
    mock_price_on_satoshis
    mock_prices_hash
    mock_create_invoice_products
  end

  it { expect(perform).to be_a(Invoice) }

  it 'creates a new Invoice in data base' do
    expect { perform }.to change { Invoice.all.count }.by(1)
  end

  it 'creates a new Invoice with correct amount' do
    expect(perform.amount).to eq(50_000_000)
  end

  it 'creates a new Invoice with correct clp' do
    expect(perform.clp).to eq(5_000)
  end

  it 'creates a new Invoice with correct memo' do
    expect(perform.memo).to eq(memo)
  end

  it 'creates a new Invoice with correct r_hash' do
    expect(perform.r_hash).to eq('r_hash')
  end

  it 'creates a new Invoice with correct payment request' do
    expect(perform.payment_request).to eq('payment_request')
  end

  it 'calls GetPriceOnSatoshis with correct clp_price' do
    perform
    expect(GetPriceOnSatoshis)
      .to have_received(:for)
      .with(clp_price: 5_000)
  end

  it 'calls CreateInvoiceProducts with correct params' do
    invoice = perform
    expect(CreateInvoiceProducts)
      .to have_received(:for)
      .with(invoice: invoice, prices_hash: prices_hash, products_hash: products_hash)
  end

  it 'calls LightningNetworkClient.create_invoice with correct params' do
    perform
    expect(lightning_network_client)
      .to have_received(:create_invoice)
      .with(memo, 50_000_000)
  end

  it 'calls GetPricesHash with correct params' do
    perform
    expect(GetPricesHash)
      .to have_received(:for)
      .with(products_hash)
  end

  context 'with 0 satoshis' do
    let(:prices_hash) { { product_a.id => 0, product_b.id => 0 } }

    it 'raises satoshi amount error' do
      expect { perform }.to raise_error('Invalid satoshi amount')
    end
  end

  context 'with error when creating invoice products' do
    before do
      allow(CreateInvoiceProducts)
        .to receive(:for) do
          3.times { create(:invoice_product) }
          raise ActiveRecord::RecordInvalid
        end
    end

    it 'raises corresponding error and does not create new invoice' do
      expect { perform }.to raise_error(ActiveRecord::RecordInvalid)
      expect(Invoice.all.count).to eq(0)
      expect(InvoiceProduct.all.count).to eq(0)
    end
  end

  context 'with error when getting products hash' do
    before do
      allow(GetPricesHash)
        .to receive(:for)
        .and_raise('Error when getting prices hash')
    end

    it 'raises corresponding error and does not create new invoice' do
      expect { perform }.to raise_error('Error when getting prices hash')
      expect(Invoice.all.count).to eq(0)
    end
  end
end
