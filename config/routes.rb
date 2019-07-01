Rails.application.routes.draw do
  root 'pages#welcome'
  get 'buy', to: 'pages#buy'
  scope path: '/api' do
    api_version(module: 'Api::V1', path: { value: 'v1' }, defaults: { format: 'json' }) do
      resources :products, only: [:index]
      get '/satoshi_price', to: 'prices#satoshi_price'
      get 'products/:product_id', to: 'products#get'
      resources :invoices, only: [:create]
      get 'invoices/status/:r_hash', to: 'invoices#status'
      get '/gif', to: 'gifs#show_random'
    end
  end
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  mount Sidekiq::Web => '/queue'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_scope :user do
    get 'suppliers/sign_up', to: 'devise/registrations#new'
    get 'suppliers/sign_in', to: 'devise/sessions#new'
  end

  resource :user do
    resources :user_products, path: '/products', as: 'products'
    resources :withdrawals
    resources :ledger_accounts, path: '/balance', as: 'balance'
    resources :lightning_network_withdrawals
  end

  post 'user/withdrawals/validate', to: 'withdrawals#validate'
end
