class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  # POST /auth/login
  def login
    # byebug
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])  #user&.authenticate
      token = jwt_encode(user_id: user.id)
      render json: { token: token}, status: :ok
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  # private

  # def login_params
  #   params.permit(:email, :password)
  # end

end