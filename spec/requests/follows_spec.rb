require 'rails_helper'
include JsonWebToken

RSpec.describe "Follows", type: :request do
  let(:current_user) { create(:user) }
  let(:user) { create(:user) }
  let(:valid_jwt) { jwt_encode(user_id: current_user.id) }

  describe 'POST /follow' do
    it 'follows a user' do
      post "/follows/#{user.id}/follow",
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
      expect(current_user.followees).to include(user)
    end
    it "returns an error if a user tries to follow themself" do
      # byebug
      post "/follows/#{current_user.id}/follow",
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it "returns an error if a listener tries to follow another listener" do
      current_user.update(user_type: 'Listener')
      user.update(user_type: 'Listener')
      post "/follows/#{user.id}/follow",
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it "returns an error if a artist tries to follow another listener" do
      current_user.update(user_type: 'Artist')
      user.update(user_type: 'Listener')
      post "/follows/#{user.id}/follow",
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'failed to find user' do
      post "/follows/0/follow", 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'post /unfollow' do
    before do 
      current_user.followees << user
    end
    it 'unfollows a user' do
      post "/follows/#{user.id}/unfollow",
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
      expect(current_user.followees).not_to include(user)
    end
    it 'returns an error if the user is not following the artist' do
      post "/follows/#{user.id}/unfollow",
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET /all_followers' do
    before do
      user.followees << current_user
    end
    it 'returns a list of followers' do
      # byebug
      # followers = user.followees
      # followers
      get "/follows/all_followers",
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(1)
    end
    it 'returns an error if the user has no followers' do
      user.followees.delete_all
      get "/follows/all_followers",
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /all_followees' do
    it 'returns a list of followees' do
      current_user.followees << user
      get "/follows/all_followees",
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns an error if the user is not following anyone' do
      get "/follows/all_followees",
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end

  # describe "GET /follows" do
  #   it "works! (now write some real specs)" do
  #     get follows_path
  #     expect(response).to have_http_status(200)
  #   end
  # end
end
