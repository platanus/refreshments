class LightningNetworkWithdrawal < ApplicationRecord
  include PowerTypes::Observable
  include AASM
  aasm column: 'state' do
    state :pending, initial: true
    state :confirmed, :rejected

    event :confirm do
      transitions from: :pending, to: :confirmed
    end

    event :reject do
      transitions from: :pending, to: :rejected
    end
  end
end

# == Schema Information
#
# Table name: lightning_network_withdrawals
#
#  id           :bigint(8)        not null, primary key
#  invoice_hash :string           not null
#  state        :string
#  user_id      :bigint(8)        not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  amount       :integer
#  memo         :string
#
# Indexes
#
#  index_lightning_network_withdrawals_on_user_id  (user_id)
#
