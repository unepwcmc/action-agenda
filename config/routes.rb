Rails.application.routes.draw do
  devise_for :users
  unauthenticated :user do
    root to: 'home#index', as: :unauthenticated_root
  end
  authenticated :user do
    root to: 'users#dashboard', as: :root
  end

  get '/home', to: 'home#index', as: 'home'

  get '/dashboard', to: 'users#dashboard', as: 'dashboard'
  get '/about', to: 'about#show', as: 'about'

  resources :commitments
  post '/commitments/list', to: 'commitments#list'

  resources :criteria, only: [:new, :create]
  get '/criteria/:id/ineligible', to: 'criteria#ineligible', as: 'ineligible_criteria'

  resources :links, only: [:update, :destroy]
  resources :progress_documents, only: [:update, :destroy]
  resources :country_commitments, only: [:show, :index]

  namespace :admin do
    resources :imported_commitments, only: [:index, :update]
  end
end
