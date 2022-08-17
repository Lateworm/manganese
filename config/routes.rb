Rails.application.routes.draw do
  resources :plays
  resources :events
  resources :sources
  resources :services
  resources :recommendations
  resources :albums
  devise_for :users
  resources :artists
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "events#index"
end
