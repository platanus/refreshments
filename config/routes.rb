Rails.application.routes.draw do
  root 'pages#welcome'
  get 'buy', to: 'pages#buy'
  scope path: '/api' do
    api_version(module: 'Api::V1', path: { value: 'v1' }, defaults: { format: 'json' }) do
      resources :invoices, only: [:create]
      resources :products, only: [:index, :show] do
        get 'seller', to: 'products#seller'
      end
      resources :websocket, only: [:create]
      get 'invoices/status/:r_hash', to: 'invoices#status'
      get '/satoshi_price', to: 'prices#satoshi_price'
      get '/gif', to: 'gifs#show_random'
      get '/notify_payment_error', to: 'sentry#notify_payment_error'
      put '/debt_products', to: 'debt_products#debt_products'
      get '/statistics/fee_balance'
      get '/slack', to: 'slack#get_users'
      post '/slack', to: 'slack#notify_user'
    end
  end
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  mount Sidekiq::Web => '/queue'
  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_scope :user do
    get 'suppliers/sign_up', to: 'devise/registrations#new'
    get 'suppliers/sign_in', to: 'devise/sessions#new'
  end

  resource :user do
    resources :products
    resources :withdrawals
    resources :ledger_accounts, path: '/balance', as: 'balance'
    resources :lightning_network_withdrawals
    resources :debt_products, only: [:index] do
      put '/mark_as_paid', to: 'debt_products#mark_as_paid'
    end
  end

  post 'user/withdrawals/validate', to: 'withdrawals#validate'
end
