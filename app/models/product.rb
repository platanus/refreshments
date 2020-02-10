class Product < ApplicationRecord
  include PowerTypes::Observable
  validates :name, :price, :stock, :category, presence: true
  validates :price, :stock, numericality: { greater_than_or_equal_to: 0 }
  validates :fee_rate, inclusion: { in: (0..1).step(0.001) }
  validates :image, attached: true

  scope :active, -> { where(active: true) }
  scope :with_stock, -> { where('stock > 0') }

  scope :for_sale, -> { active.with_stock }

  has_one_attached :image

  belongs_to :user
  has_many :invoice_products
  has_many :debt_products
  has_many :invoices, through: :invoice_products

  CATEGORIES = [:snacks, :drinks, :other]
  enum category: CATEGORIES, _prefix: :categories

  def fee_percentage
    fee_rate * 100
  end

  def fee_percentage=(value)
    self.fee_rate = value.to_f / 100
  end
end

# == Schema Information
#
# Table name: products
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null
#  price       :integer          not null
#  stock       :integer          not null
#  active      :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  name        :string
#  category    :integer          default("other"), not null
#  fee_rate    :decimal(, )      default(0.0), not null
#  webhook_url :string
#
# Indexes
#
#  index_products_on_user_id  (user_id)
#
