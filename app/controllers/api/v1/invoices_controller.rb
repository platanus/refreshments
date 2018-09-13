class Api::V1::InvoicesController < Api::V1::BaseController
  def create
    invoice = CreateInvoice.for(
      memo: invoice_params[:memo], products_hash: invoice_params[:products].to_hash
    )

    respond_with invoice: invoice
  end

  def status
    r_hash = URI.decode(params[:r_hash])
    respond_with settled: InvoiceUtils.status(r_hash)
  end

  private

  def invoice_params
    params.require(:invoice).permit(:memo, products: {})
  end
end
