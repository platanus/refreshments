FactoryBot.define do
  factory :lightning_network_withdrawal do
    invoice_hash { 'W8LmuwDP0Nk614ktkoeT9JsjiYFEQeap' }
    state { 'pending' }
    association :user, factory: :user
  end
end
