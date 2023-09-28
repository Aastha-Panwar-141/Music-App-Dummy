Rails.application.routes.draw do
  # resources :follows

  resources :users, only: [:index, :create] do
    member do
      put 'update_details', to: 'users#update'
      delete 'delete_account', to: 'users#destroy'
    end

    collection do
      post 'email_update'
      get 'artists'
      get 'listeners'
    end

    post 'follow', on: :member
    post 'unfollow', on: :member
    get 'all_followers', on: :member
    get 'all_followees', on: :member
    post 'login', on: :collection
    get 'recommended_genre', on: :member
    # get 'my_top_song', on: :collection
  end
  
  resources :artists, only: [] do
    get 'my_songs', on: :collection
    get 'my_albums', on: :collection
  end

  resources :songs, param: :page, only: [:index]

  resources :songs, except: [:index] do
    collection do
      get 'top_played', to: 'songs#my_top_songs'
      get 'top_10'
      get 'recently_played_songs'
      get 'search'
    end
  end


  resources :playlists do
    member do
      post 'add_song'
      post 'merge_playlists'
    end
    collection do
      post 'merge_playlists'
    end
  end

  post 'password/forgot', to: 'passwords#forgot'
  post 'password/reset', to: 'passwords#reset'
  put 'password/update', to: 'passwords#update'

  
end
