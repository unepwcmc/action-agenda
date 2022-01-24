Rails.application.routes.draw do
  root to: 'home#index'
  get '/', to: 'home#index'


  resources :commitments, only: [:show, :index, :new, :create, :edit, :update]
  post '/commitments/list', to: 'commitments#list'

  resources :criteria, only: [:new, :create]

  get '/criteria/:id/ineligible', to: 'criteria#ineligible', as: 'ineligible_criteria'
end
