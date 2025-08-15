Rails.application.routes.draw do
  get 'announcements/create'

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root to: "pages#home"

  resources :tournaments, only: [:show, :new, :create, :index] do
    member { patch :start }  # => start_tournament_path(@tournament)
    resources :announcements, only: [:create]
    resources :invites, only: [:create] do
      collection { post :share }
    end
  end

  post "invites/:token/accept", to: "invites#accept", as: :accept_invite
  post "invites/:token/decline", to: "invites#decline", as: :decline_invite

  # Defines the root path route ("/")
  # root "posts#indeSx"
end
