require 'rails_helper'
include JsonWebToken

RSpec.describe "Splits", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:split) { FactoryBot.create(:split) }
  let(:valid_jwt) { jwt_encode(user_id: user.id) }

  describe 'get splits' do
    it 'returns list of splits' do
      byebug
      splits = FactoryBot.create_list(:split, 5)
      get "/splits",
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it 'when no splits' do
      get "/splits",
      headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end
end
