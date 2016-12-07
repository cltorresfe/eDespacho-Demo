Rails.application.routes.draw do
  get 'main/index'

  resources :warehouses
  devise_for :users, controllers: { registrations: 'users/registrations'}
  resources :users_admin, :controller => 'users'

  root 'main#index'
end
