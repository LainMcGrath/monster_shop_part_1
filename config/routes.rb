Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "welcome#index"
  get "/merchants", to: "merchants#index"
  get "/merchants/new", to: "merchants#new"
  get "/merchants/:id", to: "merchants#show"
  post "/merchants", to: "merchants#create"
  get "/merchants/:id/edit", to: "merchants#edit"
  patch "/merchants/:id", to: "merchants#update"
  delete "/merchants/:id", to: "merchants#destroy"

  get "/items", to: "items#index"
  get "/items/:id", to: "items#show"
  get "/items/:id/edit", to: "items#edit"
  patch "/items/:id", to: "items#update"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  get 'merchants/:merchant_id/items/:items_id/edit', to: "items#edit"
  patch 'merchants/:merchant_id/items/:item_id', to: "merchant/items#update"
  delete 'merchants/:merchant_id/items/:item_id', to: "merchant/items#destroy"
  delete "/items/:id", to: "items#destroy"

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  get "/reviews/:id/edit", to: "reviews#edit"
  patch "/reviews/:id", to: "reviews#update"
  delete "/reviews/:id", to: "reviews#destroy"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  delete "/cart/:item_id/quantity", to: "cart#remove_item_quantity"
  get "/cart", to: "cart#show"
  patch "/cart", to: "cart#update_coupon"

  get "/orders/:coupon_id/submit", to: "coupon_orders#new"
  post "/orders/:coupon_id/new", to: "coupon_orders#create"

  get "/orders/new", to: "orders#new"
  post "/orders", to: "orders#create"
  get "/orders/:id", to: "orders#show"
  patch "/orders/:id", to: "orders#cancel"

  get "/register", to: "users#new"
  post "/users", to: "users#create"
  get "/users", to: "sessions#show"

  get "/profile", to: "users#show"
  get "/profile/orders", to: "orders#index"
  get "profile/orders/:id", to: "orders#show"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/profile/edit", to: "users#edit"
  patch "/profile", to: "users#update"
  get "/profile/password/edit", to: "users#edit"
  patch "/profile/password", to: "users#update"

  namespace :merchant do
    get '/', to: "merchant#show"
    get '/coupons/new', to: "coupons#new"
    post '/coupons', to: "coupons#create"
    get '/coupons/:coupon_id/edit', to: "coupons#edit"
    patch '/coupons/:coupon_id', to: "coupons#update"
    get '/coupons/:coupon_id', to: "coupons#show"
    delete '/coupons/:coupon_id', to: "coupons#destroy"
    get '/:merchant_id/items', to: "items#index"
    get '/orders/:id', to: 'orders#show'
    get '/:merchant_id/items/new', to: "items#new"
    post '/:merchant_id/items', to: "items#create"
    get '/orders/:order_id/item_orders/:item_order_id/fulfill', to: 'item_orders#fulfill'
  end

  namespace :admin do
    get '/', to: "admins#show"
    get '/merchants/', to: "merchants#index"
    patch '/merchants/:merchant_id', to: 'merchants#update'
    get '/merchants/:merchant_id', to: "merchants#show"
    get '/users', to: "users#index"
    get '/users/:user_id/', to: "users#show"
    get '/users/:user_id/profile/edit', to: "users#edit"
    patch '/users/:user_id/profile', to: "users#update"
    get '/users/:user_id/password/edit', to: "users#edit"
    patch 'users/:user_id/password', to: "users#update"
    get '/users/:user_id/upgrade_to_merchant_employee', to: "users#change_role"
    get '/users/:user_id/upgrade_to_merchant_admin', to: "users#change_role"
    patch '/orders/:id', to: "orders#update"
  end

  scope :admin do
    get '/merchants/:merchant_id/items', to: "merchant/items#index"
  end
end
