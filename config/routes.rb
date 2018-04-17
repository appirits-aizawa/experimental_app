Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :webhooks, param: :content_hash

  resource :slack, only: :show do
    post :exec
  end

  namespace :api do
    resource :slack, only: [] do
      post ':content_hash/exec', to: 'slacks#exec', as: :exec_api_slack
      post :exec_json
    end
  end
end
