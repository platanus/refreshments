class ModifyProductChannel < ApplicationCable::Channel
  def subscribed
    stream_from "modify_product_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    ActionCable.server.broadcast "modify_product_channel", message: data['message']
  end
end
