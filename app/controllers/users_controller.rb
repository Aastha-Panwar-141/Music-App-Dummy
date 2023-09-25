class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create, :login]
  # before_action :set_user, only: [:show, :destroy, :update]
  
  # before_action :authorize_request, except: :create
  before_action :find_user, only: %i[update destroy]
  before_action :validate_email_update, only: :update

  
  # GET /users
  def index
    render json: User.all, status: :ok
  end
  
  def artists
    artists = User.where(user_type: 'Artist')
    if artists.size !=0
      render json: artists
    else
      render json: "No Artist available!"
    end
  end
  
  def listeners
    listeners = User.where(user_type: 'Listener')
    if listeners.size !=0
      render json: listeners
    else
      render json: "No Listener available!"
    end
  end
  
  def show
    render json: @current_user
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.with(user: @user).welcome_email.deliver_now
      render json: { data: @user, message: 'User successfully created' }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def update
    if @current_user.id == @user.id && @current_user.user_type == 'Artist'
      if @current_user.update(user_params)
        render json: { message: 'User updated', data: @current_user}
      else
        render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: {error: 'You are not authorized!'}
    end
  end
  
  def destroy
    if @current_user.destroy
      render json: { data: @current_user, message: 'User deleted' }, status: :no_content
    else
      render json: { message: 'User deletion failed' }
    end
  end
  
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

  def recommended_by_genre
    genre = params[:genre]
    recommended_tracks = Song.where(genre: genre)
    render json: recommended_tracks, status: :ok
  end

  def owns?(playlist)
    self.id == playlist.user_id
  end

  
  private
  
  def user_params
    params.permit(:username, :email, :password, :user_type)
  end
  
  def find_user
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {error: 'No record found for given id.'}
    end
  end

  def validate_email_update
    @new_email = params[:email].to_s.downcase

    if @new_email.blank?
      return render json: { status: 'Email cannot be blank' }, status: :bad_request
    end

    if  @new_email == @current_user.email
      return render json: { status: 'Current Email and New email cannot be the same' }, status: :bad_request
    end

    if User.email_used?(@new_email)
      return render json: { error: 'Email is already in use.'}, status: :unprocessable_entity
    end
  end

  def email_update
    token = params[:token].to_s
    user = User.find_by(confirmation_token: token)
  
    if !user || !user.confirmation_token_valid?
      render json: {error: 'The email link seems to be invalid / expired. Try requesting for a new one.'}, status: :not_found
    else
      user.update_new_email!
      render json: {status: 'Email updated successfully'}, status: :ok
    end
  end
  

end