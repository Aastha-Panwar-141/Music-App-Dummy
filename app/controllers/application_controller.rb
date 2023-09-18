class ApplicationController < ActionController::API
  include JsonWebToken
  
  before_action :authenticate_request
  
  # def not_found
  #   render json: { error: 'not_found' }
  # end
  
  private
  #this function has responsibility for authorizing user requests
  
  def authenticate_request
    begin
      header = request.headers['Authorization']
      header = header.split(" ").last if header
       
      #decode JWT token and get user id
      decoded = jwt_decode(header)
      # byebug
      @current_user = User.find(decoded[:user_id])

      if @current_user.user_type == 'Artist'
        @current_user = Artist.find(decoded[:user_id])
      end
      
    rescue JWT::DecodeError => e
      render json: { error: 'Invalid token' }
    rescue ActiveRecord::RecordNotFound
      render json: "Not authorized..."
    end
  end
  
end