# frozen_string_literal: true

Rails.application.routes.draw do
  root 'homes#index'

  get 'homes/index', to: 'homes#index'
  get    '/admin_login',   to: 'admin_sessions#new'
  post   '/admin_login',   to: 'admin_sessions#create'
  delete '/admin_logout',  to: 'admin_sessions#destroy'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :tenants
  resources :users
  resources :menus
  resources :receipts
  resources :expenditures
  resources :order_details, only: [:create, :destroy]
  resources :financial_summaries, only: [:index, :show] do
    get '/:date', action: :show, on: :collection, as: 'date'
    collection do
      post :compile
    end
  end
end
