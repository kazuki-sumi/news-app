require 'sidekiq/web'

Rails.application.routes.draw do
  root to: "home#index"
  resources :users
  namespace :admin do
    get "/", to: "home#index"
    resources :users
    resources :operators
    resources :password_resets, only: [:new, :create, :edit, :update]
    resources :articles
    resources :categories, except: [:show]
    resources :article_files
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
  end
  resources :articles, only: :index
  namespace :ranking do
    get "pv", to: "articles#index"
    get "pv/:category_name", to: "articles#index"
    get "comment", to: "articles#index"
    get "comment/:category_name", to: "articles#index"
    get "user/pv", to: "users#index"
    get "user/pv/:category_name", to: "users#index"
    get "user/comment", to: "users#index"
    get "user/comment/:category_name", to: "users#index"
  end
  resources :comments, only: [:create]
  get "pages/:slug", to: "articles#show", as: :article
  get "pages/:category_name/:slug", to: "articles#show", as: :category_article
  mount Sidekiq::Web, at: "/sidekiq"
  namespace :admin do
    get "*path", controller: "base", action: "render_404"
  end
  get "*path", controller: "application", action: "render_404"
end
