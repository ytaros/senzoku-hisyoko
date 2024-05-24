# frozen_string_literal: true

Rails.application.routes.draw do
  root 'homes#index'

  get 'homes/index', to: 'homes#index'
  get    '/admin_login',   to: 'admin_sessions#new'
  post   '/admin_login',   to: 'admin_sessions#create'
  delete '/admin_logout',  to: 'admin_sessions#destroy'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'

  resources :tenants
  resources :users
end
