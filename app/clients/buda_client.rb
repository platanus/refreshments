require 'base64'
require 'openssl'

class BudaClient
  BASE_URI = ENV.fetch('BUDA_BASE_URI')
  @@class_lock = Mutex.new

  def quotation(market_id:, type:, amount:)
    http_method = 'POST'
    path = "#{BASE_URI}/markets/#{market_id}/quotations"
    body = create_quotation_request_body(type, amount)
    send_buda_request(http_method, path, body)
  end

  def generate_withdrawal(amount, target_address, simulate = false)
    scope = '/currencies/btc/withdrawals'
    http_method = 'POST'
    path = "#{BASE_URI}#{scope}"
    body = create_withdrawal_request_body(amount, target_address, simulate)
    headers = headers(http_method, "/api/v2#{scope}", body)
    send_buda_request(http_method, path, body, headers)
  end

  private

  def generate_nonce
    (Time.now.to_f.round(3) * 1000).to_i.to_s
  end

  def signature(request_type, path, nonce, payload = nil)
    if payload.nil?
      "#{request_type} #{path} #{nonce}"
    else
      "#{request_type} #{path} #{Base64.strict_encode64(payload)} #{nonce}"
    end
  end

  def headers(request_type, path, payload = nil)
    nonce = generate_nonce
    encrypted_signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha384'),
      ENV.fetch('BUDA_API_SECRET'), signature(request_type, path, nonce, payload))
    {
      'X-SBTC-APIKEY' => ENV.fetch('BUDA_API_KEY'),
      'X-SBTC-NONCE' => nonce,
      'X-SBTC-SIGNATURE' => encrypted_signature,
      'Content-Type' => 'application/json'
    }
  end

  def create_withdrawal_request_body(amount, target_address, simulate)
    {
      amount: amount,
      withdrawal_data: {
        target_address: target_address
      },
      amount_includes_fees: true,
      simulate: simulate
    }.to_json
  end

  def create_quotation_request_body(type, amount)
    {
      type: type,
      amount: amount
    }
  end

  def send_buda_request(http_method, path, body, headers = nil)
    @@class_lock.synchronize do
      case http_method

      when 'GET'
        raise NotImplementedError

      when 'POST'
        post_request(path, body, headers)

      when 'PATCH'
        raise NotImplementedError

      when 'PUT'
        raise NotImplementedError

      when 'DELETE'
        raise NotImplementedError

      end
    end
  end

  def post_request(path, body, headers)
    params = { body: body }
    params[:headers] = headers unless headers.nil?
    HTTParty.post(path, params)
  end
end
