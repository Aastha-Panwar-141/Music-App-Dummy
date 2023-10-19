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
      # get '/users' 
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /users/artists' do
    it 'if no artist found' do
      get '/users/artists', headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'returns a list of artists' do
      artist
      get '/users/artists', headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end

  # describe 'GET #listeners' do
  #   it 'returns a list of listener' do
  #     get '/users/listeners', headers: { 'Authorization' => "Bearer #{valid_jwt}" }
  #     expect(response).to have_http_status(:ok)
  #   end
  #   it 'if no listener found' do
  #     get '/users/listeners'
  #     expect(response).to have_http_status(:unprocessable_entity)
  #   end
  # end
  
  describe 'POST #create' do
    it 'creates a new user' do
      post '/users', params: { username: "Aastha", email: "aastha@gmail.com", password: "admin@123", user_type: 'Artist' }
      expect(response).to have_http_status(:created)
    end
    it 'failed to create a new user' do
      post '/users', params: { username: nil }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  
  describe 'PUT #update' do
    it 'updates the user' do
      put '/users/:id/update_details', params: { id: user.id, user: { username: "Aastha", email: "aastha@gmail.com", password: "admin@123", fav_genre: "Lofi" } }, headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    # it 'failed to update user' do
    #   put '/users/:id/update_details', params: {email: ""}
    #   expect(response).to have_http_status(:unprocessable_entity)
    # end
  end
  
  describe 'DELETE #destroy' do
    it 'destroys the user' do
      # request.headers['Authorization'] = "Bearer #{valid_jwt}"
      delete '/users/:id/delete_account', params: { id: user.id }, headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end
end

