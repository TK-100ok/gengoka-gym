Rails.application.routes.draw do
  get "contacts/show"
  get "settings/index"
  devise_for :users,
    controllers: {
      registrations: "users/registrations"
    }

  root "top#index"

  get "home", to: "home#index"
  resources :trainings, only: %i[index new create show] do
    member do
      get :result
    end

    resource :post, only: %i[create destroy]
    resource :favorite, only: %i[create destroy]
  end

  resources :posts, only: :index
  resources :favorites, only: :index

  resource :contact, only: :show

  get "settings", to: "settings#index"
  get "terms", to: "static_pages#terms"
  get "privacy_policy", to: "static_pages#privacy_policy"
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
