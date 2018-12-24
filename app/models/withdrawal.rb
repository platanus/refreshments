class Withdrawal < ApplicationRecord
  include AASM

  aasm do
    state :pending, initial: true
    state :confirmed

    event :confirm do
      transitions from: :pending, to: :confirmed
    end
  end

  validates :amount, presence: true

  belongs_to :user
end

# == Schema Information
#
# Table name: withdrawals
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)        not null
#  amount     :bigint(8)
#  aasm_state :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_withdrawals_on_user_id  (user_id)
#
