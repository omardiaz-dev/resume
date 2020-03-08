Rails.application.routes.draw do
  get '/search', to: 'searches#new'
  post '/search', to: 'searches#show'

  get 'test/index'

  root 'hello#index'  

  get "consumeservice/show" 



end
