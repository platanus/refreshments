class Wallet < ApplicationRecord
  def available_funds
    LedgerAccount.find_or_create_by(category: 'available_funds', accountable: self)
  end
end

# == Schema Information
#
# Table name: wallets
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
