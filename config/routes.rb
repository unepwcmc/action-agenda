Rails.application.routes.draw do
  root to: 'home#index'
  get '/', to: 'home#index'

  get '/commitments', to: 'commitments#index'

  get '/commitments/:id', to: 'commitments#show', as: 'commitment'
  post '/commitments/list', to: 'commitments#list'

end
