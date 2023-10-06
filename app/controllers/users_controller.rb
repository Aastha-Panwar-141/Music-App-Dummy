class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create, :login]  
  before_action :find_user, only: %i[update destroy recommended_genre]
  # before_action :validate_email_update, only: :update

  def index
    render json: User.all, status: :ok
  end
  
  def artists
    artists = Artist.all
    if artists.present?
      render json: artists
    else
      render json: "No Artist available!"
    end
  end
  
  def listeners
    listeners = Listener.all
    if listeners.present?
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
    if email_changed? && !@new_email.blank? && @new_email != @current_user.email
     # byebug
      return render json: { status: 'Email cannot be changed to an existing email' }, status: :bad_request
    end
    if @current_user.update(user_params)
    # if @current_user.update(user_params.except(:email))
      render json: { message: 'User updated', data: @current_user}
    else
      render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # def update
  #  # if @current_user.id == @user.id && @current_user.user_type == 'Artist'
  #   if @current_user.update(user_params)
  #     render json: { message: 'User updated', data: @current_user}
  #   else
  #     render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

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
      render json: {error: "No records."}, status: :bad_request
    end
  end

  def all_splits
    if @current_user.split_requests.present?
      @splits = @current_user.split_requests
      render json: @splits
    else
      render json: {error: "You have no split!"}
    end
  end

  def all_share_requests
    if @current_user.share_requests.present?
      @share_requests = @current_user.share_requests
      render json: @share_requests
    else
      render json: {error: "You have no share request!"}
    end
  end

  def all_sent_requests
    # byebug
    if @current_user.sent_requests.present?
      @sent_requests = @current_user.sent_requests
      render json: @sent_requests
    else
      render json: {error: "You have no sent request!"}
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
      render json: {error: 'No record found for given id.'}, status: :bad_request
    end
  end

  def email_changed?
    params[:email] && params[:email].to_s.downcase != @current_user.email
  end

  def validate_email_update
    @new_email = params[:email].to_s.downcase

    if @new_email.blank?
      return render json: { status: 'Email cannot be blank' }, status: :bad_request
    end

    if  @new_email == @current_user.email
      return render json: { status: 'Current Email and New email cannot be the same' }, status: :bad_request
    end
  end
  

end



