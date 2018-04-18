Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :webhooks, param: :content_hash

  resource :slack, only: :show do
    post :exec
  end

  namespace :api do
    resource :gitlab, only: [] do
      post ':content_hash/exec', to: 'gitlabs#exec', as: :exec
    end
  end
end
