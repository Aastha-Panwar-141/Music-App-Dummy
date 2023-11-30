class UsersController < ApplicationController
  # skip_before_action :authenticate_request, only: [:create, :login, :new, :index]  
  before_action :find_user, only: %i[update destroy recommended_genre]
  before_action :check_owner, only: [:update, :destroy]
  
  def index
    @users = User.all
    flash.now[:notice] = "We have exactly #{@users.size} album available."

    # render json: User.all, status: :ok
  end
  
  def new 
    user = User.new 
  end

  def show
    user = User.find_by_id(params[:id])
  end

  def artists
    @artists = Artist.all
    if @artists.present?
      # render json: @artists, status: :ok
    else
      render json: "No Artist available!", status: :unprocessable_entity
    end
  end
  
  def listeners
    @listeners = Listener.all
    if @listeners.present?
      # render json: @listeners, status: :ok
    else
      render json: "No Listener available!", status: :unprocessable_entity
    end
  end
  
  def create
    # byebug 
    @user = User.new(user_params)
    if @user.save
      UserMailer.with(user: @user).welcome_email.deliver_now
      render json: { data: @user, message: 'User successfully created' }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def update
    if @current_user.update(user_params)
      render json: { message: 'User updated', data: @current_user}, status: :ok
    else
      render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    if @current_user
      @current_user.destroy
      render json: { message: "User Account Deleted" }, status: :ok
    else
      render json:{ error: "can't find artist" }, status: :unprocessable_entity
    end
  end
  
  def login
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])  #user&.authenticate
      token = jwt_encode(user_id: user.id)
      render json: { token: token}, status: :ok
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end
  
  def recommended_genre 
    fav_genre = @user.fav_genre
    recommended_by_genre = Song.where(genre: fav_genre)
    render json: {recommended_songs: recommended_by_genre}
  end
  
  private
  def user_params
    params.permit(:username, :email, :password, :user_type, :fav_genre)
  end
  
  def find_user
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {error: 'No record found for given id.'}, status: :unprocessable_entity
    end
  end
  
  def check_owner
    unless @user.id == @current_user.id  
      render json: {error: "you are not authorize for this action!"}, status: :unauthorized
    end
  end
end



