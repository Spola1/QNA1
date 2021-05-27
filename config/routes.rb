require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', registrations: 'oauth_registrations'}

  root to: "questions#index"
  get :search, to: 'search#search'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me,  on: :collection
      end

      resources :questions, only: %i[index show create update destroy] , shallow: true do
        resources :answers, only: %i[index show create update destroy]
      end
    end
  end

  resources :attachments, only: %i[destroy]
  resources :links,       only: %i[destroy]
  resources :awards,      only: %i[index destroy]

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      patch :vote_cancel
    end
  end

  resources :questions, concerns: [:votable] do
    resources :subscriptions, only: %i[create destroy], shallow: true
    resources :answers, concerns: [:votable], only: %i[create update edit destroy], shallow: true do
      member do
        patch :best
      end
      resources :comments, only: %i[create], defaults: { commentable: 'answer'}
    end
    resources :comments, only: %i[create], defaults: { commentable: 'question'}
  end

  mount ActionCable.server => '/cable'
end
