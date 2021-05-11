Rails.application.routes.draw do
  devise_for :users

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
    end
  end
end
