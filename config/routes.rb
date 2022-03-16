Rails.application.routes.draw do
  devise_for :users
  unauthenticated :user do
    root to: 'home#index', as: :unauthenticated_root
  end
  authenticated :user do
    root to: 'users#dashboard', as: :root
  end

  resources :commitments
  post '/commitments/list', to: 'commitments#list'

  resources :criteria, only: [:new, :create]
  resources :links, only: [:update, :destroy]
  resources :progress_documents, only: [:update, :destroy]
  
  get '/criteria/:id/ineligible', to: 'criteria#ineligible', as: 'ineligible_criteria'

  get '/dashboard', to: 'users#dashboard', as: 'dashboard'
  get '/about', to: 'about#show', as: 'about'
end
