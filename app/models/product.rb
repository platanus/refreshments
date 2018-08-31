class Product < ApplicationRecord
  validates :name, :price, presence: true
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
#
