Rails.application.routes.draw do
  root to: "admins#index"
  namespace :admin do
    resources :users
    resources :articles, except: [:index, :show]
  end
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
end
