class LedgerAccount < ApplicationRecord
  belongs_to :accountable, polymorphic: true
end

# == Schema Information
#
# Table name: ledger_accounts
#
#  id               :bigint(8)        not null, primary key
#  category         :string
#  accountable_type :string
#  accountable_id   :bigint(8)
#  balance          :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_ledger_accounts_on_accountable_type_and_accountable_id  (accountable_type,accountable_id)
#
