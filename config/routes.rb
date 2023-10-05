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
    post 'login', on: :collection
    get 'recommended_genre', on: :member
  end
  
  resources :artists do
    get 'my_songs', on: :collection
    get 'my_albums', on: :collection
  end

  resources :albums

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
      # post 'merge_playlists'
    end
    collection do
      post 'merge_playlists'
    end
  end

  resources :follows, only: [] do 
    member do 
      post 'follow'
      post 'unfollow'
    end
    collection do
      get 'all_followers'
      get 'all_followees' 
    end
  end

  resources :share_requests do 
    member do
      post 'accept'
      post 'reject' 
    end
    collection do
      get 'my_requests'
    end
  end

  resources :splits

  resources :splits do
    post 'share_requests'
  end

  # resources :share_requests

  post 'password/forgot', to: 'passwords#forgot'
  post 'password/reset', to: 'passwords#reset'
  put 'password/update', to: 'passwords#update'

  
end
