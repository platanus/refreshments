class Api::V1::SentryController < Api::V1::BaseController
  def notify_payment_error
    raise "user's payment didn't work"
  end
end
