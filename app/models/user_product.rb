class UserProduct < ApplicationRecord
  validates :name, :price, :stock, presence: true
  validates :price, :stock, numericality: { greater_than_or_equal_to: 0 }
  validates :image, attached: true

  scope :active, -> { where(active: true) }
  scope :with_stock, -> { where('stock > 0') }

  scope :for_sale, -> { active.with_stock }

  has_one_attached :image

  belongs_to :user
  belongs_to :product
  has_many :invoice_products
  has_many :invoices, through: :invoice_products

  validate :prevent_change_of_product, on: :update

  def prevent_change_of_product
    if product_id_changed?
      errors.add :product_id, :cant_change_product_reference
    end
  end
end

# == Schema Information
#
# Table name: user_products
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)        not null
#  product_id :bigint(8)        not null
#  price      :integer          not null
#  stock      :integer          not null
#  active     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string
#
# Indexes
#
#  index_user_products_on_product_id  (product_id)
#  index_user_products_on_user_id     (user_id)
#
