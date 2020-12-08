Rails.application.routes.draw do
  root to: 'home#index'
  get '/', to: 'home#index'

  get '/commitments', to: 'commitments#index'
  get '/commitment/:id', to: 'commitments#show'
end
