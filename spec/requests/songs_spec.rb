require 'rails_helper'
include JsonWebToken


RSpec.describe "Songs", type: :request do
  # let(:user) { FactoryBot.create(:user) }
  # let(:artist) { FactoryBot.create(:user, user_type: 'Artist') }
  # let(:listener) { FactoryBot.create(:user, user_type: 'Listener') }
  # # let(:song) { FactoryBot.create(:song) }
  # let(:valid_jwt) { jwt_encode(user_id: user.id) }
  # let(:valid_jwt) { jwt_encode(user_id: user.id) }
  
  let(:artist) { create(:artist) }
  let(:listener) { create(:listener) }
  let(:user) { create(:user) }
  let(:valid_jwt_artist) { jwt_encode(user_id: artist.id) }
  let(:valid_jwt_listener) { jwt_encode(user_id: listener.id) }
  let(:valid_jwt) { jwt_encode(user_id: user.id) }

  let!(:public_song) { create(:song, status: 'public', artist: artist) }
  let!(:private_song) { create(:song, status: 'private', artist: artist) }

  # before(:all) do
  #   @song = create(:song)
  #   # @song = Song.create(id: 1, title: 'Heeriye', genre: 'Lofi', user_id: 1, album_id: 2, status: 'public')
  # end

  describe 'GET /songs' do
    it 'get list of songs for an artist' do
      artist.songs << public_song
      get '/songs',
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:ok)
    end
    it 'get list of songs for a listener' do
      artist.songs << public_song
      get '/songs',
      headers: { 'Authorization' => "Bearer #{valid_jwt_listener}" }
      expect(response).to have_http_status(:ok)
    end
    it 'if no song exist' do 
      no_song_id = 123456789
      get "/songs/#{no_song_id}",
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  
  describe 'GET /songs/:id' do
    it 'shows a song' do
      get "/songs/#{public_song.id}",
      headers: { 'Authorization' => "Bearer #{valid_jwt_listener}" }
      expect(response).to have_http_status(:ok)
    end
    it 'shows a private song for a follower' do
      artist.songs << private_song
      get "/songs/#{private_song.id}",
      headers: { 'Authorization' => "Bearer #{valid_jwt_listener}" }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(private_song.title)
    end
    it 'returns an error for a private song if not following' do
      get "/songs/#{private_song.id}",
      headers: { 'Authorization' => "Bearer #{valid_jwt_listener}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'POST /songs' do
    it 'creates a song' do
      post '/songs', 
      params: { title: 'New Song', genre: 'Rock', album_id: 1, status: 'public' },
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:created)
    end
    it 'returns an error for an invalid song' do
      post '/songs', 
      params: { title: ''},
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /songs/:id' do
    it 'updates a song' do
      put "/songs/#{public_song.id}", 
      params: { title: "New Song Title" },
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:ok)
      expect(public_song.reload.title).to eq("New Song Title")
    end
    it 'returns an error for an invalid update' do
      put "/songs/#{public_song.id}", 
      params: { title: '' },
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /songs/:id' do
    it 'deletes a song' do
      delete "/songs/#{public_song.id}",
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:ok)
      expect(Song.exists?(public_song.id)).to be_falsey
    end
    it 'returns an error for a failed delete' do
      delete "/songs/#{public_song.id}",
      headers: { 'Authorization' => "Bearer #{valid_jwt_listener}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET #search' do
    it 'returns search results for a query' do
      song = FactoryBot.create(:song)
      get "/songs/search", 
      params: { query: 'Heer' }, 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns an error when no results are found' do
      get "/songs/search", 
      params: { query: 'NotFound' }, 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns an error if no query is provided' do
      get "/songs/search", 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #top_10' do
    it 'returns the top 10 played songs' do
      byebug
      songs = FactoryBot.create_list(:song, 10)
      songs.each { |s| s.increment!(:play_count) }
      get "/songs/top_10", 
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(10)
    end
  end

  describe 'GET #my_top_songs' do
    it 'returns the top played songs for the user' do
      user_song = FactoryBot.create(:song, user_id: user.id)
      other_user_song = FactoryBot.create(:song)
      user_song.increment!(:play_count)
      get "/songs/my_top_songs", 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns an error if no top songs are found for the user' do
      get "/songs/my_top_songs", 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET #recently_played_songs' do
    it 'returns recently played songs for the user' do
      user = FactoryBot.create(:user, user_type: 'Listener')
      artist = FactoryBot.create(:user, user_type: 'Artist')
      user_song = FactoryBot.create(:song, user_id: artist.id)
      user.recentyly_playeds.create(song: user_song)
      get "/songs/recently_played_songs", 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns an error if no recently played songs are found for the user' do
      user = FactoryBot.create(:user, user_type: 'Listener')
      get "/songs/recently_played_songs", 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:bad_request)
    end
  end
end
