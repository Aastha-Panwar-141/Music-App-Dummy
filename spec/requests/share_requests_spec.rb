require 'rails_helper'
include JsonWebToken

RSpec.describe "ShareRequests", type: :request do
  let(:listener) { create(:listener) }
  let(:artist) { create(:artist) }
  let(:split) { create(:split) }
  let(:share_request) { create(:share_request) }
  let(:valid_jwt_listener) { jwt_encode(user_id: listener.id) }
  let(:valid_jwt_artist) { jwt_encode(user_id: artist.id) }

  describe 'GET #share_requests' do
    it 'returns a list of share requests' do
      share_request
      get '/share_requests', 
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:ok)
    end
    it 'if no share request avialable' do
      get '/share_requests', 
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET #all_splits' do
    it 'returns a list of share requests' do
      split
      get '/users/my_splits', 
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:ok)
    end
    it 'if no share request avialable' do
      get '/users/my_splits', 
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'POST /share_requests' do
    it 'creates a share request' do
      post '/share_requests',
      params: { split_id: split.id, price: 10, requested_percent: 20 },
      headers: { 'Authorization' => "Bearer #{valid_jwt_listener}" }
      expect(response).to have_http_status(:created)
    end
    it 'returns an error for an invalid request' do
      post '/share_requests',
      params: { split_id: nil, price: nil, requested_percent: nil },
      headers: { 'Authorization' => "Bearer #{valid_jwt_listener}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /share_requests/:id/accept' do
    it 'accepts a share request' do
      request = create(:share_request, split: split, requester: listener, receiver: artist)
      post "/share_requests/#{request.id}/accept",
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns an error for an invalid accept request' do
      request = create(:share_request, split: split, requester: listener, receiver: artist)
      request.update(status: 'accepted')
      post "/share_requests/#{request.id}/accept",
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /share_requests/:id/reject' do
    it 'rejects a song request' do
      request = create(:share_request, split: split, requester: listener, receiver: artist)
      post "/share_requests/#{request.id}/reject",
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns an error for an invalid reject request' do
      request = create(:share_request, split: split, requester: listener, receiver: artist)
      request.update(status: 'accepted')
      post "/share_requests/#{request.id}/reject",
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /share_requests/:id' do
    it 'deletes a song' do
      delete "/share_requests/#{share_request.id}",
      headers: { 'Authorization' => "Bearer #{valid_jwt_artist}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns an error for a failed delete' do
      delete "/share_requests/#{share_request.id}",
      headers: { 'Authorization' => "Bearer #{valid_jwt_listener}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
