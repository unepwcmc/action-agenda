WcmcComponents::Engine.routes.draw do
  post '/', to: 'table#list'
  post '/download', to: 'table#download'
end
