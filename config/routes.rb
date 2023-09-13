Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :users
  resources :artists
  resources :listeners
  
  post '/auth/login', to: 'authentication#login'
  # post '/auth/signup', to: 'authentication#signup'
  # get '/*a', to: 'application#not_found'


end
