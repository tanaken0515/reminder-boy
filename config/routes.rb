Rails.application.routes.draw do
  get '/reminders', to: 'reminders#index'
  get 'reminders/new'
  get 'reminders/show'
  get 'reminders/edit'
  get '/login', to: 'sessions#new'
  get '/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  root to: 'sessions#new'
end
