Rails.application.routes.draw do
  get 'main/index'

  resources :warehouses
  resources :sale_distpaches, only: [:create, :new]
  resources :sales, only: [:show]
  resources :gmovs, only: [:index]
  devise_for :users
  resources :users_admin, :controller => 'users'

  get "search" => "search#search", as: :search
  

  root 'main#index'
end
