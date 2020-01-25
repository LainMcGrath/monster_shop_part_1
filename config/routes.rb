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

  scope :profile do
    get "/edit", to: "users#edit"
    get "/", to: "users#show"
    patch "/", to: "users#update"

    scope :orders do
      get "/", to: "orders#index"
      get "/:id", to: "orders#show"
    end

    scope :password do
      get "/edit", to: "users#edit"
      patch "/", to: "users#update"
    end
  end

  scope :register do
    get "/", to: "users#new"
  end

  scope :users do
    post "/", to: "users#create"
    get "/", to: "sessions#show"
  end

  scope :login do
    get "/", to: "sessions#new"
    post "/", to: "sessions#create"
  end

  scope :logout do
    delete "/", to: "sessions#destroy"
  end

  namespace :merchant do
    get '/', to: "merchant#show"
    get '/:merchant_id/items', to: "items#index"
    get '/:merchant_id/items/new', to: "items#new"
    post '/:merchant_id/items', to: "items#create"

    scope :coupons do
      get '/new', to: "coupons#new"
      post '/', to: "coupons#create"
      get '/:coupon_id/edit', to: "coupons#edit"
      patch '/:coupon_id', to: "coupons#update"
      get '/:coupon_id', to: "coupons#show"
      delete '/:coupon_id', to: "coupons#destroy"
    end

    scope :orders do
      get '/:id', to: 'orders#show'
      get '/:order_id/item_orders/:item_order_id/fulfill', to: 'item_orders#fulfill'
    end
  end

  namespace :admin do
    get '/', to: "admins#show"

    scope :merchants do
      get '/', to: "merchants#index"
      patch '/:merchant_id', to: 'merchants#update'
      get '/:merchant_id', to: "merchants#show"
    end

    scope :users do
      get '/', to: "users#index"
      get '/:user_id/', to: "users#show"
      get '/:user_id/profile/edit', to: "users#edit"
      patch '/:user_id/profile', to: "users#update"
      get '/:user_id/password/edit', to: "users#edit"
      patch '/:user_id/password', to: "users#update"
      get '/:user_id/upgrade_to_merchant_employee', to: "users#change_role"
      get '/:user_id/upgrade_to_merchant_admin', to: "users#change_role"
    end

    patch '/orders/:id', to: "orders#update"
  end

  scope :admin do
    scope :merchants do
      get '/:merchant_id/orders/:id', to: "orders#show"
      get '/:merchant_id/items', to: "merchant/items#index"
    end
  end
end
