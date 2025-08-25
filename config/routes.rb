Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  get "up" => "rails/health#show", as: :rails_health_check
  root to: "pages#home"

  resources :tournaments, only: [:show, :new, :create, :index] do
    member do
      patch :start
      get   :bracket
      get   "bracket/:match_id", to: "matches#show", as: :bracket_match
    end

    resources :announcements, only: [:create]   # <-- nested here
    resources :invites, only: [:create] do
      collection { post :share }
    end
  end

  # Remove the non-nested announcements route and stray GET
  # resources :announcements, only: [:create]
  # get 'announcements/create'

  resources :matches, only: [:show] do
    member { patch :update_score }
  end

  post "invites/:token/accept",  to: "invites#accept",  as: :accept_invite
  post "invites/:token/decline", to: "invites#decline", as: :decline_invite
end
