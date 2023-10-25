require 'rails_helper'

RSpec.describe "Splits", type: :request do
  let(:user) { FactoryBot.create(:user) }
  # let(:valid_jwt) { jwt_encode(user_id: user.id) }

  before(:all) do 
    @split = Split.create(id: 1, requester_id: 2, receiver_id: 3, split_type: 'Artist')
  end

  describe 'GET #index' do
    it 'returns a list of splits' do
      @split
      get "/splits"
      expect(response).to have_http_status(:ok)
    end
    it 'if no split' do
      get "/splits"
      if @split.nil?
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
