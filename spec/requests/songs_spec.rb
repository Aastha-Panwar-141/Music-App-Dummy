require 'rails_helper'
include JsonWebToken


RSpec.describe "Songs", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:artist) { FactoryBot.create(:user, user_type: 'Artist') }
  let(:listener) { FactoryBot.create(:user, user_type: 'Listener') }
  # let(:song) { FactoryBot.create(:song) }
  let(:valid_jwt) { jwt_encode(user_id: user.id) }
  let(:valid_jwt_artist) { jwt_encode(user_id: artist.id) }
  let(:valid_jwt_listener) { jwt_encode(user_id: listener.id) }
  # let(:valid_jwt) { jwt_encode(user_id: user.id) }

  before(:all) do
    byebug
    @song = Song.create(id: 1, title: 'Heeriye', genre: 'Lofi', user_id: 1, album_id: 2, status: 'public')
  end

  describe 'GET #index' do
    it 'returns a list of songs for an artist' do
      @song
      get '/songs', headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns a list of songs for a listener' do
      @song
      get '/songs', headers: { 'Authorization' => "Bearer #{valid_jwt_listener}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns an error for an unauthorized user' do
      get '/songs', headers: { 'Authorization' => "Bearer #{valid_jwt_user}" }
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'GET #show' do
    it 'shows a song for an artist' do
      get "/songs/#{@song.id}", headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:ok)
    end
    it 'shows a song for a listener' do
      get "/songs/#{@song.id}", headers: { 'Authorization' => "Bearer #{valid_jwt_listener}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns an error for an unauthorized user' do
      get "/songs/#{@song.id}", headers: { 'Authorization' => "Bearer #{valid_jwt_user}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  # describe 'GET #index' do
  #   it 'returns a list of songs' do
  #     get '/songs', headers: { 'Authorization' => "Bearer #{valid_jwt}" }
  #     expect(response).to have_http_status(:ok)
  #   end
  # end


  # describe 'GET #show' do
  #   it 'listen a song' do
  #     get "/songs/#{@song.id}", headers: { 'Authorization' => "Bearer #{valid_jwt}" }
  #     expect(response).to have_http_status(:ok)
  #   end
  #   it 'returns an error for unauthorized user' do
  #     get "/songs/#{@song.id}", headers: { 'Authorization' => "Bearer #{valid_jwt}" }
  #     expect(response).to have_http_status(:unprocessable_entity)
  #   end
  # end

  #   describe "GET #show" do
  #     it  'returns a success response' do 
  #       song = Song.create!(title: 'Song 1', genre: 'Lofi', user_id: 41, album_id: 14)
  #       get :show, params: {id: song.to_param}
  #       expect(response).to be_success # response.success?
  #     end
  #     # pending "add some examples (or delete) #{__FILE__}"
  #   end 
end
