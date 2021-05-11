Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :attachments, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :awards, only: %i[index destroy]

  resources :questions do
    resources :answers, except: :index, shallow: true do
      member do
        patch :best
      end
    end
  end
end
