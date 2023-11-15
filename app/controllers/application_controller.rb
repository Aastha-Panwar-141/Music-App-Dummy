class ApplicationController < ActionController::Base
  include JsonWebToken
  before_action :authenticate_user!
  # before_action :authenticate_request
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery prepend: true
  # protect_from_forgery with: :null_session

  private

  # def authenticate_request
  #   begin
  #     header = request.headers['Authorization']
  #     header = header.split(" ").last if header
  #     #decode JWT token and get user id
  #     decoded = jwt_decode(header)
  #     @current_user = User.find(decoded[:user_id])
  #     if @current_user.user_type == 'Artist'
  #       @current_user = Artist.find(decoded[:user_id])
  #     end
  #     if @current_user.user_type == 'Listener'
  #       @current_user = Listener.find(decoded[:user_id])
  #     end
  #   rescue JWT::DecodeError => e   # error related to token: missing, expired, invalid, etc.
  #     render json: { error: 'Invalid token' }
  #   rescue ActiveRecord::RecordNotFound
  #     render json: "Not authorized..."
  #   end
  # end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :user_type, :fav_genre])
  end

end