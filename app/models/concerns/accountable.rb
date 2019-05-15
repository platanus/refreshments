module Accountable
  extend ActiveSupport::Concern

  included do
    has_many :ledger_lines, as: :accountable
  end
end
