Rails.application.routes.draw do
  
  # Routes for main resources
  resources :addresses
  resources :orders
  resources :items
  resources :carts
  resources :customers

  # Semi-static page routes
  resources :sessions
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :search
  get 'home/admin_dashboard', to: 'home#admin_dashboard', as: :admin_dashboard
  get 'home/cust_dashboard', to: 'home#cust_dashboard', as: :customers_dashboard

  post 'user_signup', to: 'customers#new', as: :user_signup

  get 'baking_list', to: 'sessions#baking_list', as: :baking_list

  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  get 'add_to_cart/:id', to: 'carts#add_to_cart', as: :add_to_cart

  # Set the root url
  root :to => 'home#home'
  
end
