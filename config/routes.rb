Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "welcome#index"

  resources :merchants

  resources :items, only: [:index, :show, :edit, :update, :destroy] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  scope :merchants do
    get "/:merchant_id/items", to: "items#index"
    get "/:merchant_id/items/new", to: "items#new"
    post "/:merchant_id/items", to: "items#create"
    get '/:merchant_id/items/:items_id/edit', to: "items#edit"
  end

  scope :merchants, module: :merchant do
    patch '/:merchant_id/items/:item_id', to: "items#update"
    delete '/:merchant_id/items/:item_id', to: "items#destroy"
  end

  scope :cart do
    post "/:item_id", to: "cart#add_item"
    get "/", to: "cart#show"
    delete "/", to: "cart#empty"
    delete "/:item_id", to: "cart#remove_item"
    delete "/:item_id/quantity", to: "cart#remove_item_quantity"
    get "/", to: "cart#show"
    patch "/", to: "cart#update_coupon"
  end

  scope :orders do
    get "/new", to: "orders#new"
    post "/", to: "orders#create"
    get "/:id", to: "orders#show"
    patch "/:id", to: "orders#cancel"
  end

  get "/profile/orders", to: "orders#index"
  get "profile/orders/:id", to: "orders#show"

  get "/register", to: "users#new"
  post "/users", to: "users#create"
  get "/profile", to: "users#show"
  get "/profile/edit", to: "users#edit"
  patch "/profile", to: "users#update"
  get "/profile/password/edit", to: "users#edit"
  patch "/profile/password", to: "users#update"


  get "/users", to: "sessions#show"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

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

  get 'admin/merchants/:merchant_id/orders/:id', to: "orders#show"

  scope :admin do
    get '/merchants/:merchant_id/items', to: "merchant/items#index"
  end
end
