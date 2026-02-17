Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :services
  resources :bookings

  devise_scope :user do
    get "sign_up", to: "devise/registrations#new"
    get "sign_in", to: "devise/sessions#new"
    match "sign_out", to: "devise/sessions#destroy", via: %i[get delete]
  end
  # Defines the root path route ("/")
  # root "posts#index"
  root "services#index"

  match "*path", to: "application#not_found", via: :all

  namespace :api do
    namespace :v1 do
      resources :services
      resources :bookings
    end
  end
end
