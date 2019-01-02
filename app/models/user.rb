class User < ApplicationRecord
  validates :name, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :products
  has_many :invoices, through: :products
  has_many :withdrawals

  def total_sales
    Product.where(user_id: id)
           .joins(invoice_products: :invoice)
           .where('invoices.settled=true')
           .sum('floor(price * (amount::numeric / clp))::integer')
  end

  def total_withdrawals
    withdrawals.where.not(aasm_state: :rejected).sum(:amount)
  end

  def total_pending_withdrawals
    withdrawals.where(aasm_state: :pending).sum(:amount)
  end

  def total_confirmed_withdrawals
    withdrawals.where(aasm_state: :confirmed).sum(:amount)
  end

  def withdrawable_amount
    total_sales - total_withdrawals
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string           not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
