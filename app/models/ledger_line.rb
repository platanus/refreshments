class LedgerLine < ApplicationRecord
  belongs_to :ledger_account
  belongs_to :accountable, polymorphic: true

  scope :before_date, ->(date) { where("date < ?", date) }
  scope :after_date, ->(date) { where("date >= ?", date) }
  scope :sorted, -> { order(date: :asc, id: :desc) }
  scope :sorted_desc, -> { order(date: :desc, id: :desc) }
end

# == Schema Information
#
# Table name: ledger_lines
#
#  id                :bigint(8)        not null, primary key
#  ledger_account_id :bigint(8)
#  accountable_type  :string
#  accountable_id    :bigint(8)
#  date              :date
#  amount            :integer
#  balance           :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_ledger_lines_on_accountable_type_and_accountable_id  (accountable_type,accountable_id)
#  index_ledger_lines_on_ledger_account_id                    (ledger_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (ledger_account_id => ledger_accounts.id)
#
