Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :users
  # resources :artists
  resources :artists do
    resources :songs
    resources :albums
  end
  resources :listeners do
    resources :playlists
  end
  
  post '/auth/login', to: 'authentication#login'

  # post '/artists/songs', to: 'artists#add_song'
  
  # post '/auth/signup', to: 'authentication#signup'
  # get '/*a', to: 'application#not_found'


end
