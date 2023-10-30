require 'rails_helper'
include JsonWebToken


RSpec.describe "Albums", type: :request do
  
  let(:user) { FactoryBot.create(:user, user_type: 'Artist') }
  # let(:album) { FactoryBot.create(:album, user_id: user.id) }
  let(:song) { FactoryBot.create(:song) }
  let(:valid_jwt) { jwt_encode(user_id: user.id) }
  
  # let(:artist) { create(:artist) }
  let(:listener) { create(:listener) }
  # let(:valid_jwt_artist) { jwt_encode(user_id: artist.id) }
  let(:valid_jwt_listener) { jwt_encode(user_id: listener.id) }
  
  describe 'GET #index' do
    it 'returns a list of albums' do
      albums = FactoryBot.create_list(:album, 5)
      get '/albums', 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    # it 'if no album vaialable' do
    #   get '/albums', 
    #   headers: { 'Authorization' => "Bearer #{valid_jwt}" }
    #   expect(response).to have_http_status(:unprocessable_entity)
    # end
  end
  
  describe 'POST #create' do
    it 'creates a new album with a valid song' do
      post '/albums', 
      params: { title: 'My album', song_id: song.id }, 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:created)
    end
    # it 'check owner' do
    #   user = FactoryBot.create(:user, user_type: 'Listener')
    #   # album = FactoryBot.create(:album, user_id: user.id)
    #   post "/albums/",  
    #   params: { title: "New album Title" },
    #   headers: { 'Authorization' => "Bearer #{valid_jwt}" }
    #   expect(response).to have_http_status(:unauthorized)
    # end
    # it 'validate artist' do
    #   listener = FactoryBot.create(:listener)
    #   # byebug
    #   # album = FactoryBot.create(:album)
    #   post '/albums', 
    #   headers: { 'Authorization' => "Bearer #{valid_jwt_listener}" }
    #   expect(response).to have_http_status(:unprocessable_entity)
    # end
  end
  
  describe 'PUT /albums/:id' do
    it 'update a album' do
      album = FactoryBot.create(:album, user_id: user.id)
      put "/albums/#{album.id}", 
      params: { title: "New album Title" },
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
      expect(album.reload.title).to eq("New album Title")
    end
    it 'returns an error for an invalid update' do
      album = FactoryBot.create(:album, user_id: user.id)
      put "/albums/#{album.id}", 
      params: { title: '' },
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'if album id not found' do
      # byebug
      album = FactoryBot.create(:album, user_id: user.id)
      put "/albums/0", 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'check owner' do
      another_user = FactoryBot.create(:user, user_type: 'Artist')
      album = FactoryBot.create(:album, user_id: another_user.id)
      put "/albums/#{album.id}",  
      params: { title: "New album Title" },
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unauthorized)
    end
    
  end
  
  describe 'DELETE /albums/:id' do
    it 'delete a album' do
      album = FactoryBot.create(:album, user_id: user.id)
      delete "/albums/#{album.id}",
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    
  end
end
