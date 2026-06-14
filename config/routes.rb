Rails.application.routes.draw do
  get "favorites/index"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "top#index"

  get "home", to: "home#index"
  resources :trainings, only: %i[index new create show] do
    member do
      get :result
    end

    resource :post, only: :create
  end

  resources :posts, only: %i[index]
  resources :favorites, only: :index

  get "terms", to: "static_pages#terms"
  get "privacy_policy", to: "static_pages#privacy_policy"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
