Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/create'
  get 'password_resets/edit'
  get 'password_resets/update'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Defines the root path route ("/")
  # root "articles#index"
  
  resources :users, only: [:index, :create] do
    member do
      put 'update_details', to: 'users#update'
      delete 'delete_account', to: 'users#destroy'
    end
    
    collection do
      post 'email_update'
    end
  end
  
  get '/users/artists', to: 'users#artists'
  get '/users/listeners', to: 'users#listeners'
  get 'songs/top_played', to: 'songs#top_played_songs'
  get 'songs/recommended_by_genre', to: 'songs#recommended_by_genre'
  get 'songs/top_10', to: 'songs#top_10'

  resources :songs do 
    collection do
      get :search
      get :search_by_genre
    end
  end

  
  resources :albums
  resources :playlists

  resources :artists do
    get 'my_songs', on: :collection
    get 'my_albums', on: :collection
  end
  
  post '/users/login', to: 'users#login'
    
  post 'password/forgot', to: 'passwords#forgot'
  post 'password/reset', to: 'passwords#reset'
  put 'password/update', to: 'passwords#update'

  
  # resources :artists
  # resources :artists do
  #   resources :songs
  #   resources :albums
  # end
  # resources :listeners do
  #   resources :playlists
  # end
  
  
  # post '/artists/songs', to: 'artists#add_song'
  
  # post '/auth/signup', to: 'authentication#signup'
  # get '/*a', to: 'application#not_found'
  
  
end
