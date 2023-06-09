Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :users
  resources :requests
  resources :conversations
  resources :messages
  post '/auth/login' => 'authentification#create'

  mount ActionCable.server => "/cable"


end
