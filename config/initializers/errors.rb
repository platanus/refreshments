module BudaClientError
  class BadResponseError < StandardError; end
  class NetworkError < StandardError; end
end

module LightningNetworkClientError
  class ClientError < StandardError; end
end
