Rails.application.routes.draw do
  
  # Routes for main resources
  resources :addresses
  resources :orders
  resources :items
  resources :carts
  resources :customers
  resources :users

  # Semi-static page routes
  resources :sessions
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :search
  
  get 'admin_dashboard', to: 'customers#admin_dashboard', as: :admin_dashboard
  get 'cust_dashboard', to: 'customers#cust_dashboard', as: :customers_dashboard

  post 'customers/new', to: 'customers#new', as: :user_signup

  get 'baking_list', to: 'sessions#baking_list', as: :baking_list

  # get 'cust_address', to: 'addresses#cust_address', as: :cust_address

  get 'shipping_list', to: 'sessions#shipping_list', as: :shipping_list

  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  get 'add_to_cart/:id', to: 'carts#add_to_cart', as: :add_to_cart
  get 'checkout', to: 'carts#checkout', as: :checkout

  patch 'item_inactive/:id', to: 'items#item_inactive', as: :item_inactive

  get 'order_cust', to: 'orders#order_cust', as: :order_cust

  get 'clear_all_cart', to: 'carts#clear_all_cart', as: :clear_all_cart
  patch 'remove_item/:id', to: 'carts#remove_item', as: :remove_item

  patch 'mark_unshipped/:id', to: 'order_items#mark_unshipped', as: :mark_unshipped
  patch 'mark_shipped/:id', to: 'order_items#mark_shipped', as: :mark_shipped

  get 'item_price_admin/:id', to: 'item_prices#item_price_admin', as: :item_price_admin
  post 'item_prices', to: 'item_prices#create', as: :item_prices

  # Set the root url
  root :to => 'home#home'
  
end
