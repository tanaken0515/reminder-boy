require 'sidekiq/web'
require 'sidekiq-scheduler/web'

class AdminConstraint
  def matches?(request)
    user_id = request.session[:user_id]

    User.find_by(id: user_id)&.role_admin? if user_id
  end
end

Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  get '/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  root to: 'reminders#index'

  resources :reminders, except: :destroy do
    resources :thread_reminders, only: [:new, :create, :edit, :update]
  end

  resources :remind_logs, only: [:index]

  namespace :account do
    resource :settings, only: [:show, :update]
  end

  namespace :admin do
    resources :users, only: [:index]
    mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new

    root to: 'users#index'
  end
end
