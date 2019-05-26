Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  get '/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  root to: 'reminders#index'

  resources :reminders
end
