class InvoicesChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'invoices'
  end
end