ActiveAdmin.register Withdrawal do
  permit_params :amount, :user_id, :btc_address
  actions :index, :show, :new, :create

  index do
    id_column
    column :amount
    column :user
    column :btc_address
    state_column :aasm_state
    column :created_at
    actions
  end

  filter :amount
  filter :created_at
  filter :user
  filter :btc_address

  form do |f|
    f.inputs do
      f.input :amount
      f.input :user
      f.input :btc_address
    end
    f.actions
  end
end
