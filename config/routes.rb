Rails.application.routes.draw do
  get 'main/index'

  resources :warehouses
  resources :sale_distpaches, only: [:create, :new, :index, :destroy], shollow: true do
  	resources :gmov_distpaches
  end
  resources :sales, only: [:show]
  resources :gmovs, only: [:index]
  devise_for :users
  resources :users_admin, :controller => 'users'
  resources :quotes
  resources :customer_quotes

  get "search" => "search#search", as: :search
  get "search_distpaches" => "search#search_distpaches", as: :search_distpaches
  get "search_costs" => "search#search_costs", as: :search_costs
  get "search_registro_existencia" => "search#search_registro_existencia", as: :search_registro_existencia
  get "search_stock_products" => "search#search_stock_products", as: :search_stock_products
  get "carro_cotizacion" => "quotes#carro_cotizacion", as: :carro_cotizacion
  post "llamada_ajax" => "search#llamada_ajax", as: :llamada_ajax
  get "buscardor_autocomplete" => "search#buscardor_autocomplete", as: :buscardor_autocomplete
  

  root 'main#index'
end
