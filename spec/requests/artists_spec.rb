require 'rails_helper'
include JsonWebToken


RSpec.describe "Artists", type: :request do
  let(:user) { FactoryBot.create(:user, user_type: 'Artist') }
  let(:valid_jwt) { jwt_encode(user_id: user.id) }
  
  describe 'my songs' do
    it 'fetch artist songs' do
      get "/artists/my_songs", 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end
  
  describe 'my albums' do
    it 'fetch artist albums' do
      get "/artists/my_albums", 
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end
  
  # describe "GET /artists" do
  #   it "works! (now write some real specs)" do
  #     get artists_path
  #     expect(response).to have_http_status(200)
  #   end
  # end
end
