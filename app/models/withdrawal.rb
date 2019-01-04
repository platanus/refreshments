class Withdrawal < ApplicationRecord
  MIN_BUDA_AMOUNT = 9999
  SATOSHIS_TO_BTC = 10**-8

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
  validates :amount, numericality: { greater_than: MIN_BUDA_AMOUNT, only_integer: true }
  validate :amount_cant_be_greater_than_user_withdrawable_amount, on: :create
  validate :address_is_valid_btc_address

  belongs_to :user

  after_create_commit :add_job_to_withdrawal_requests_worker

  def amount_cant_be_greater_than_user_withdrawable_amount
    if amount && amount > user.withdrawable_amount
      errors.add(:amount, "Amount can't be greater than user balance")
    end
  end

  def address_is_valid_btc_address
    if !/^[13mn][a-km-zA-HJ-NP-Z1-9]{25,33}$/.match(btc_address)
      errors.add(:btc_address, 'BTC address must be a valid one')
    end
  end

  def add_job_to_withdrawal_requests_worker
    withdrawal_request_worker.perform_async(id)
  end

  def btc_amount
    (amount * SATOSHIS_TO_BTC).to_f
  end

  private

  def withdrawal_request_worker
    @withdrawal_request_worker ||= WithdrawalRequestsWorker
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
