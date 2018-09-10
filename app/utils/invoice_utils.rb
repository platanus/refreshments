module InvoiceUtils
  extend self

  def status(r_hash)
    r_hash_str = Base64.decode64(r_hash).bytes.map { |n| '%02X' % (n & 0xFF) }.join
    lightning_network_client.invoice(r_hash_str)["settled"]
  end

  def lightning_network_client
    @lightning_network_client ||= LightningNetworkClient.new
  end
end
