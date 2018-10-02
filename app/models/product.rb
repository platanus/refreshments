class Product < ApplicationRecord
  validates :name, :price, presence: true

  has_one_attached :image
  scope :actives, -> { where(active: true) }
end

# == Schema Information
#
# Table name: products
#
#  id         :bigint(8)        not null, primary key
#  price      :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  active     :boolean          default(TRUE)
#
