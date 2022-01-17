Rails.application.routes.draw do
  root to: 'home#index'
  get '/', to: 'home#index'

  get '/commitments', to: 'commitments#index', as: 'commitments'

  get '/commitments/:id', to: 'commitments#show', as: 'commitment'
  post '/commitments/list', to: 'commitments#list'

  resources :failed_criteria, only: [:show]

  resources :criteria, only: [:new, :create] do
    resources :commitments, only: [:new]
  end
end
