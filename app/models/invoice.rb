class Invoice < ApplicationRecord
  validates :clp, :memo, :payment_request, :r_hash, :satoshis, presence: true
end

# == Schema Information
#
# Table name: invoices
#
#  id              :bigint(8)        not null, primary key
#  satoshis        :integer
#  clp             :integer
#  payment_request :string
#  r_hash          :string
#  memo            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
