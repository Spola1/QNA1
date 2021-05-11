Rails.application.routes.draw do
  resources :questions do
    resources :answers, except: :index, shallow: true
  end
end
