Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions do
    resources :answers, only: %i[create update edit destroy], shallow: true do
      member do
        patch :best
      end
    end
  end
end
