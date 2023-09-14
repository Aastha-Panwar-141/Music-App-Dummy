class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:index, :create, :login]
  # before_action :set_user, only: [:show, :destroy, :update]

  # before_action :authorize_request, except: :create
  # before_action :find_user, except: %i[create index]

  # GET /users
  def index
    users = User.all
    if users.size != 0
      render json: users
    else
      render json: 'There is no Artist and Listener available!'
    end
    # render json: users, status: :ok
  end

  def login
    if user = User.find_by(email: params[:email], password: params[:password])
      token = jwt_encode(user_id: user.id)
      render json: { message: 'Logged In Successfully..', token: token }
    else
      render json: { error: 'Please Check your Email And Password.....' }
    end
  end


  # # GET /users/{username}
  # def show
  #   render json: @user, status: :ok
  # end

  # # POST /users
  # def create
  #   user = User.new(user_params)
  #   if user.save
  #     render json: user, status: :created
  #   else
  #     render json: { errors: user.errors.full_messages },
  #            status: :unprocessable_entity
  #   end
  # end

  # # PUT /users/{username}
  # def update
  #   unless @user.update(user_params)
  #     render json: { errors: @user.errors.full_messages },
  #            status: :unprocessable_entity
  #   end
  # end

  # # DELETE /users/{username}
  # def destroy
  #   @user.destroy
  # end

  # private

  # def set_user
  #   @user = User.find(params[:id])
  #   rescue ActiveRecord::RecordNotFound
  #     render json: { errors: 'User not found' }, status: :not_found
  # end

  # def user_params
  #   params.permit(
  #     :username, :email, :password
  #   )
  # end

  
end