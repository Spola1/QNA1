Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', registrations: 'oauth_registrations'}

  root to: "questions#index"

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
