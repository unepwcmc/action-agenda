Rails.application.routes.draw do
  root to: 'home#index'
  get '/', to: 'home#index'


  resources :commitments, only: [:show, :index, :new]
  post '/commitments/list', to: 'commitments#list'

  resources :criteria, only: [:new, :create]

  get '/criteria/:id/ineligible', to: 'criteria#ineligible', as: 'ineligible_criteria'

  get '/dashboard', to: 'users#dashboard', as: 'dashboard'
end
