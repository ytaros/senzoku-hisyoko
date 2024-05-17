Rails.application.routes.draw do
  root 'homes#index'

  get 'homes/index', to: 'homes#index'
end
