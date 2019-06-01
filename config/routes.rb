Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  get '/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  root to: 'reminders#index'

  resources :reminders do
    member do
      put 'post_message', to: 'reminders#post_message'
    end
  end

  resources :remind_logs, only: [:index]
end
