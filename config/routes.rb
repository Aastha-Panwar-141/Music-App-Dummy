require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  
  resources :users, only: [:index, :create] do
    member do
      put 'update_details', to: 'users#update'
      delete 'delete_account', to: 'users#destroy'
    end
    
    collection do
      # post 'email_update'
      get 'artists'
      get 'listeners'
      get 'my_splits', to: 'share_requests#all_splits'
      get 'all_share_requests', to: 'share_requests#all_share_requests'
      get 'all_sent_requests', to: 'share_requests#all_sent_requests'
      get 'purchased_splits', to: 'share_requests#purchased_splits'
      get 'all_song_sent_requests', to: 'song_requests#all_sent_requests'
      get 'all_accepted_request', to: 'song_requests#all_accepted_request'
      
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
  
  # resources :splits
  
  resources :splits do
    post 'share_requests', to: 'share_requests#create'
    # post 'song_requests', to: 'song_requests#create'
  end
  
  resources :song_splits do
    post 'song_requests', to: 'song_requests#create'
  end
  
  resources :share_requests, only: [] do
    member do
      post 'accept'
      post 'reject'
    end
  end
  
  resources :song_requests
  resources :song_requests, only: [] do
    member do
      post 'accept'
      post 'reject'
    end
  end
  
  get 'all_splits', to: 'song_requests#all_splits'
  post 'password/forgot', to: 'passwords#forgot'
  post 'password/reset', to: 'passwords#reset'
  put 'password/update', to: 'passwords#update'
  
end
