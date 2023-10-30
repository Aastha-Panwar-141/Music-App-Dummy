require 'rails_helper'
include JsonWebToken

RSpec.describe "SongReques", type: :request do
  let(:listener) { create(:listener) }
  let(:artist) { create(:artist) }
  let(:split) { create(:song_split) }
  let(:song_request) { create(:song_request) }
  let(:valid_jwt_listener) { jwt_encode(user_id: listener.id) }
  let(:valid_jwt_artist) { jwt_encode(user_id: artist.id) }

  describe 'GET #song_requests' do
    it 'returns a list of song requests' do
      song_request
      get '/song_requests', 
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:ok)
    end
    it 'if no song request avialable' do
      get '/song_requests', 
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET #splits' do
    it 'returns a list of split' do
      split
      get '/all_splits', 
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:ok)
    end
    # it 'if no split avialable' do
    #   get '/all_splits', 
    #   headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
    #   expect(response).to have_http_status(:unprocessable_entity)
    # end
  end

  describe 'POST /song_requests' do
    it 'creates a song request' do
      post '/song_requests',
      params: { song_split_id: split.id, price: 10, requested_percent: 20 },
      headers: { 'Authorization' => "Bearer #{valid_jwt_listener}" }
      expect(response).to have_http_status(:created)
    end
    it 'returns an error for an invalid request' do
      post '/song_requests',
      params: { song_split_id: nil, price: nil, requested_percent: nil },
      headers: { 'Authorization' => "Bearer #{valid_jwt_listener}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /song_requests/:id/accept' do
    it 'accepts a song request' do
      request = create(:song_request, song_split: split, requester: listener, receiver: artist)
      post "/song_requests/#{request.id}/accept",
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns an error for an invalid accept request' do
      request = create(:song_request, song_split: split, requester: listener, receiver: artist)
      request.update(status: 'accepted')
      post "/song_requests/#{request.id}/accept",
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
    # it 'failed to find id' do
    #   delete "/song_requests/0/accept",
    #   headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
    #   expect(response).to have_http_status(:unprocessable_entity)
    # end
  end

  describe 'PUT /song_requests/:id/reject' do
    it 'rejects a song request' do
      request = create(:song_request, song_split: split, requester: listener, receiver: artist)
      post "/song_requests/#{request.id}/reject",
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns an error for an invalid reject request' do
      request = create(:song_request, song_split: split, requester: listener, receiver: artist)
      request.update(status: 'accepted')
      post "/song_requests/#{request.id}/reject",
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET /song_requests/sent_requests' do
    it 'returns all sent song requests' do
      create_list(:song_request, 3, requester: listener, song_split: split)
      get '/users/all_song_sent_requests',
      headers: { 'Authorization' => "Bearer #{valid_jwt_listener}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(3)
    end
    it 'returns an error if there are no sent song requests' do
      get '/users/all_song_sent_requests',
      headers: { 'Authorization' => "Bearer #{valid_jwt_listener}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET /song_requests/accepted_requests' do
    it 'returns all accepted song requests' do
      requests = create_list(:song_request, 3, requester: listener, song_split: split)
      requests.each { |request| request.update(status: 'accepted') }
      get '/users/all_accepted_request',
      headers: { 'Authorization' => "Bearer #{valid_jwt_listener}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(3)
    end
    it 'returns an error if there are no accepted song requests' do
      get '/users/all_accepted_request',
      headers: { 'Authorization' => "Bearer #{valid_jwt_listener}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
