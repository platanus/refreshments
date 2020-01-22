class DebtProduct < ApplicationRecord
  validates :debtor, :product_id, :product_price, presence: true

  belongs_to :product
end

# == Schema Information
#
# Table name: debt_products
#
#  id            :bigint(8)        not null, primary key
#  debtor        :string
#  product_id    :bigint(8)
#  product_price :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  paid          :boolean          default(FALSE)
#
