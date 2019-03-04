require "rails_helper"

describe Api::V1::BaseController, type: :controller do
  it_behaves_like "exception_handler_controller"
end
