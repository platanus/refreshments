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
#  user_id    :bigint(8)
#
# Indexes
#
#  index_products_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

module ProductsHelper
end
