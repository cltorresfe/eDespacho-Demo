Rails.application.routes.draw do
  get 'main/index'

  resources :warehouses
  resources :sale_distpaches, only: [:create, :new], shollow: true do
  	resources :gmov_distpaches
  end
  resources :sales, only: [:show]
  resources :gmovs, only: [:index]
  devise_for :users
  resources :users_admin, :controller => 'users'

  get "search" => "search#search", as: :search
  get "search_distpaches" => "search#search_distpaches", as: :search_distpaches
  

  root 'main#index'
end
