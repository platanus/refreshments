class Invoice < ApplicationRecord
  include PowerTypes::Observable
  validates :clp, :memo, :payment_request, :r_hash, :amount, presence: true
  validates :clp, :amount, numericality: { greater_than: 0 }

  has_many :invoice_products
  has_many :user_products, through: :invoice_products
  has_many :products, through: :user_products

  scope :settled, -> { where(settled: true) }

  def satoshi_clp_ratio
    amount.to_f / clp
  end
end

# == Schema Information
#
# Table name: invoices
#
#  id              :bigint(8)        not null, primary key
#  amount          :integer          not null
#  clp             :integer
#  payment_request :string
#  r_hash          :string
#  memo            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  settled         :boolean          default(FALSE)
#
