class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  # POST /auth/login
  def login
    # byebug
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])  #user && user.authenticate
      token = jwt_encode(user_id: @user.id)
      # time = Time.now + 24.hours.to_i
      render json: { token: token}, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  # POST /auth/signup
  def signup
    puts "Signup is Working!"
  end

  # private

  # def login_params
  #   params.permit(:email, :password)
  # end

end