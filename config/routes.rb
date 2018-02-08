Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'users#home'

  get 'sessions/new'
  get '/login',      to: "sessions#new"
  post '/login',     to: "sessions#create"
  delete '/logout',  to: "sessions#destroy"

  resources :users
  get 'users/home'

  resources :events
  get 'events/new'
  get 'events/create'

end
