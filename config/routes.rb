Rails.application.routes.draw do
  root "sessions#new"

  resources :currencies, only: [:index, :show] do
    resources :pairs, only: [:show]
    post "/pairs/:id", to: "pairs#buy"
    patch "pairs/:id", to: "pairs#sell"
  end

  resources :portfolios, only: [:show, :index, :update] do
    resources :deals, only: [:index, :show]
  end

  resources :users, only: [:new, :show, :create, :index]

  resources :sessions, only: [:new, :create]
  delete "/sessions", to: "sessions#delete"

end
