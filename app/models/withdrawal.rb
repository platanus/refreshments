class Withdrawal < ApplicationRecord
  include AASM

  aasm do
    state :pending, initial: true
    state :confirmed, :rejected

    event :confirm do
      transitions from: :pending, to: :confirmed
    end

    event :reject do
      transitions from: :pending, to: :rejected
    end
  end

  validates :amount, :btc_address, presence: true
  validates :amount, numericality: { greater_than: 0, only_integer: true }
  validate :amount_cant_be_greater_than_user_withdrawable_amount, on: :create
  validate :address_is_valid_btc_address

  belongs_to :user

  def amount_cant_be_greater_than_user_withdrawable_amount
    if amount && amount > user.withdrawable_amount
      errors.add(:amount, "Amount can't be greater than user balance")
    end
  end

  def address_is_valid_btc_address
    if !/^[13][a-km-zA-HJ-NP-Z1-9]{25,33}$/.match(btc_address)
      errors.add(:btc_address, 'BTC address must be a valid one')
    end
  end
end

# == Schema Information
#
# Table name: withdrawals
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null
#  amount      :integer
#  aasm_state  :string
#  btc_address :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_withdrawals_on_user_id  (user_id)
#
