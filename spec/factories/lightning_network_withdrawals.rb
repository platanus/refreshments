FactoryBot.define do
  factory :lightning_network_withdrawal do
    invoice_hash { 'W8LmuwDP0Nk614ktkoeT9JsjiYFEQeap' }
    user_id { create(:user).id }
  end
end
