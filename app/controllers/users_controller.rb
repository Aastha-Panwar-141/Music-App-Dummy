class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create, :login]  
  before_action :find_user, only: %i[update destroy recommended_genre]
  before_action :check_owner, only: [:update, :destroy]
  
  def index
    render json: User.all, status: :ok
  end

  def artists
    # byebug

    artists = Artist.all
    if artists.present?
      render json: artists, status: :ok
    else
      render json: "No Artist available!", status: :unprocessable_entity
    end
  end

  def listeners
    listeners = Listener.all
    if listeners.present?
      render json: listeners, status: :ok
    else
      render json: "No Listener available!", status: :unprocessable_entity
    end
  end

  def show
    render json: @current_user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # byebug
      UserMailer.with(user: @user).welcome_email.deliver_now
      render json: { data: @user, message: 'User successfully created' }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    byebug
    if email_changed? && !@new_email.blank? && @new_email != @current_user.email
      byebug
      return render json: { status: 'Email cannot be changed to an existing email' }, status: :unprocessable_entity
    end
    if @current_user.update(user_params)
      byebug
      # if @current_user.update(user_params.except(:email))
      render json: { message: 'User updated', data: @current_user}, status: :ok
    else
      render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @current_user
      @current_user.destroy
      render json: { message: "User Account Deleted" }, status: 202
    else
      render json:{ error: "can't find artist" }, status: 400
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

  def recommended_genre 
    if @user.present?
      fav_genre = @user.fav_genre
      recommended_by_genre = Song.where(genre: fav_genre)
      render json: {recommended_songs: recommended_by_genre}
    else
      render json: {error: "No records."}, status: :unprocessable_entity
    end
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
    byebug
    unless @user.id == @current_user.id  
      render json: {error: "you are not authorize for this action!"}
    end
  end

  def email_changed?
    params[:email] && params[:email].to_s.downcase != @current_user.email
  end
end



