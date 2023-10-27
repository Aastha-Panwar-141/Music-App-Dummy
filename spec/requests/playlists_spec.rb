require 'rails_helper'
include JsonWebToken

RSpec.describe "Playlists", type: :request do
  let(:user) { FactoryBot.create(:user, user_type: 'Listener') }
  let(:playlist) { FactoryBot.create(:playlist, user_id: user.id) }
  let(:song) { FactoryBot.create(:song) }
  let(:valid_jwt) { jwt_encode(user_id: user.id) }
  
  describe 'GET #index' do
    it 'returns a list of playlists' do
      playlist
      get '/playlists', 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it 'if no playlist vaialable' do
      get '/playlists', 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  
  describe 'GET #show' do
    it 'returns a specific playlist' do
      get "/playlists/#{playlist.id}", 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it 'failed to find playlist' do
      get "/playlists/0", 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end
  
  describe 'POST #create' do
    it 'creates a new playlist with a valid song' do
      post '/playlists', 
      params: { title: 'My Playlist', song_id: song.id }, 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:created)
    end
    it 'fails to create a playlist without a song' do
      post '/playlists', 
      params: { title: 'My Playlist' }, 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'failed to save playlist' do 
      post '/playlists', 
      params: { title: '' }, 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /playlists/:id' do
    it 'update a playlist' do
      put "/playlists/#{playlist.id}", 
      params: { title: "New Playlist Title" },
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
      expect(playlist.reload.title).to eq("New Playlist Title")
    end
    it 'returns an error for an invalid update' do
      put "/playlists/#{playlist.id}", 
      params: { title: '' },
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /playlists/:id' do
    it 'delete a playlist' do
      delete "/playlists/#{playlist.id}",
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
      expect(Song.exists?(playlist.id)).not_to be_falsey
    end
    it 'returns an error for a failed delete' do
      delete "/playlists/#{playlist.id}",
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'POST #add_song' do
    it 'add song to a playlist' do
      post "/playlists/#{playlist.id}/add_song",
      params: { song_id: song.id },
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it 'failed if song already in playlist' do
      playlist.songs << song
      post "/playlists/#{playlist.id}/add_song",
      params: { song_id: song.id },
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'POST #merge_playlists' do
    it 'merge playlist of same owner' do
      playlist1 = FactoryBot.create(:playlist, user_id: user.id)
      playlist2 = FactoryBot.create(:playlist, user_id: user.id)

      post "/playlists/merge_playlists",
      params: { playlist1_id: playlist1.id, playlist2_id: playlist2.id, title: 'Merged Playlist' },
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it 'if error of owner' do
      playlist1 = FactoryBot.create(:playlist, user_id: user.id)
      playlist2 = FactoryBot.create(:playlist)

      post "/playlists/merge_playlists",
      params: { playlist1_id: playlist1.id, playlist2_id: playlist2.id, title: 'Merged Playlist' },
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'if playlist is missing' do
      playlist1 = FactoryBot.create(:playlist, user_id: user.id)

      post "/playlists/merge_playlists",
      params: { playlist1_id: playlist1.id, playlist2_id: 0, title: 'Merged Playlist' },
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end



  describe "GET /playlists" do
    it "works! (now write some real specs)" do
      get playlists_path
      expect(response).to have_http_status(200)
    end
  end
end
