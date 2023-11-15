require 'rails_helper'

RSpec.describe "Passwords", type: :request do
  let(:user) { create(:user) }
  let(:valid_jwt) { jwt_encode(user_id: user.id) }
  
  describe 'POST /passwords/forgot' do
    it 'sends a password reset email for a valid email' do
      byebug
      post '/password/forgot', params: { email: user.email }
      expect(response).to have_http_status(:ok)
      expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
    end
    it 'returns an error for an invalid email' do
      post '/password/forgot', params: { email: 'wrongemaill@example.com' }
      expect(response).to have_http_status(:not_found)
    end
  end
  
end
