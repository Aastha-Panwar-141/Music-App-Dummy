require 'rails_helper'
include JsonWebToken

RSpec.describe "Playlists", type: :request do
  let(:user) { FactoryBot.create(:user, user_type: 'Listener') }
  let(:playlist) { FactoryBot.create(:playlist) }
  let(:song) { FactoryBot.create(:song) }
  let(:valid_jwt) { jwt_encode(user_id: user.id) }
  
  describe 'GET #index' do
    it 'returns a list of playlists' do
      get '/playlists', 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end
  
  describe 'GET #show' do
    it 'returns a specific playlist' do
      get "/playlists/#{playlist.id}", 
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
  end
  
  describe "GET /playlists" do
    it "works! (now write some real specs)" do
      get playlists_path
      expect(response).to have_http_status(200)
    end
  end
end
