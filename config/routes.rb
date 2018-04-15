Rails.application.routes.draw do
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resource :slack, only: :show do
    post :exec
  end

  namespace :api do
    resource :slack, only: [] do
      post :exec
      post :exec_json
    end
  end
end
