require 'rails_helper'
include JsonWebToken

RSpec.describe "Users", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:listener) { FactoryBot.create(:user, user_type: 'Listener') }
  let(:artist) { FactoryBot.create(:user, user_type: 'Artist') }
  let(:other_user) { FactoryBot.create(:user) }
  let(:valid_jwt) { jwt_encode(user_id: user.id) }
  
  # let(:user) {create :user}
  # before(:each) do
  #   sign_in(:user)
  # end
  
  describe 'GET #index' do
    it 'returns a list of users' do
      get '/users', headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end
  
  describe 'GET #artists' do
    it 'if no artist found' do
      get '/users/artists', 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'returns a list of artists' do
      artist
      get '/users/artists', 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end
  
  describe 'GET #listeners' do
    it 'if no listener found' do
      get "/users/listeners",
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'returns a list of listener' do
      listener
      get "/users/listeners",
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end
  
  describe 'POST #create' do
    it 'creates a new user' do
      post '/users', params: { username: "Aastha", email: "aastha@gmail.com", password: "admin@123", user_type: 'Artist' }
      expect(response).to have_http_status(:created)
    end
    it 'failed to create a new user' do
      post "/users", params: { username: nil }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  
  describe 'PUT #update' do
    it 'updates the user' do
      put "/users/#{user.id}/update_details", 
      params: { user: { username: 'Aastha' } }, 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it 'failed to update user' do
      no_user_id = 123456789
      put "/users/#{no_user_id}/update_details",
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'check owner' do
      another_user = FactoryBot.create(:user)
      put "/users/#{another_user.id}/update_details", 
      params: { user: { username: 'Aastha' } },
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unauthorized)
    end
  end
  
  describe 'DELETE #destroy' do
    it 'destroys the user' do
      delete "/users/#{user.id}/delete_account",
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it 'failed to delete user' do
      no_user_id = 123456789
      delete "/users/#{no_user_id}/delete_account",
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'check owner' do
      another_user = FactoryBot.create(:user)
      delete "/users/#{another_user.id}/delete_account", 
      params: { user: { username: 'Aastha' } },
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unauthorized)
    end
  end
  
  describe 'GET #recommended_genre' do
    it 'returns recommended genre' do
      user.update(fav_genre: 'Lofi')
      get "/users/#{user.id}/recommended_genre", 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it 'if no user exist' do 
      no_user_id = 123456789
      get "/users/#{no_user_id}/recommended_genre",
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  
  describe 'users/login' do
    it 'login user' do
      post "/users/login", params: { user_id: user.id, email: user.email, password: user.password }
      expect(response).to have_http_status(:ok)
    end
    it 'returns unauthorized with invalid credentials' do
      post "/users/login", params: { email: nil, password: nil }
      expect(response.status).to have_http_status(:unprocessable_entity)
    end
  end
end

