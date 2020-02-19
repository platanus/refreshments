class Api::V1::InvoicesController < Api::V1::BaseController
  def create
    shopping_cart_items
    invoice = CreateInvoice.for(shopping_cart_items: shopping_cart_items)
    UpdateInvoiceStatusJob.perform_later(invoice.r_hash) if invoice

    render json: invoice
  end

  def status
    puts "status in invoices controller"
    r_hash = URI.decode(params[:r_hash])
    # r_hash = params[:r_hash]
    invoice = Invoice.find_by(r_hash: r_hash)
    settled = invoice&.settled
    # SettleInvoiceJob.perform_later(r_hash) if settled
    # DispenseProductsJob.perform_later(r_hash) if settled
    respond_with settled: settled
  end

  private

  def invoice_params
    params.require(:invoice).permit(products: {})
  end

  def shopping_cart_items
    @shopping_cart_items ||= begin
      shopping_cart_items = []
      invoice_params[:products].each do |key, value|
        shopping_cart_items.push(ShoppingCartItem.new(key, value['amount']))
      end
      shopping_cart_items
    end
  end
end
