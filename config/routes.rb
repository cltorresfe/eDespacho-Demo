Rails.application.routes.draw do
  get 'main/index'

  resources :warehouses
  devise_for :users
  resources :users_admin, :controller => 'users'

  get "search" => "search#search", as: :search

  root 'main#index'
end