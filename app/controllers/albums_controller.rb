class AlbumsController < ApplicationController
  before_action :find_album, only: [:update, :destroy, :edit, :show]
  # before_action :find_song, only: [:create]
  before_action :validate_artist
  before_action :authorize_album_owner, only: [:update, :destroy, :add_song]

  def index
    @albums = Album.all
    # byebug
    # @album = Album.find(params[:album_id])
    # @songs = @album.songs
    flash.now[:notice] = "We have exactly #{@albums.size} album available."
    if @albums.present?
      # render json: albums
    else
      render json: {error: "There is no album present!"}
    end
  end

  def new
    # byebug
    @album = Album.new
  end 
  
  def create
    # byebug
    # unless params[:song_id].present?
    #   return render json: { error: 'Song ID is required to create a album.' }, status: :unprocessable_entity
    # end
    # song_id = Song.find_by_id(params[:song_id])
    # if song_id.nil?
    #   return render json: { error: 'Song not found with the given ID' }, status: :not_found
    # end
    @album = current_user.albums.new(album_params)
    if @album.save
      redirect_to @album, notice: "Album created successfully"
      # song = Song.find_by_id(song_id)
      # @album.songs << @song
      # render json: { message: 'Album created successfully' }, status: :created
    else
      # render :new, alert: "Failed to create album"
      flash[:notice] = @album.errors.full_messages
      render "new"
      # render json: { error: @album.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
  end

  def show
  end

  # def update
  #   if @car.update(car_params)
  #     redirect_to(@car)
  #     else
  #     render “edit”
  #   end
  # end
  
  def update
    if @album.update(album_params)
      redirect_to @album, notice: "Album updated successfully"
      # render json: { message: 'Album updated successfully' }, status: :ok
    else
      render "edit"
      # render json: { error: @album.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @album.destroy
      redirect_to albums_path, notice: "Album deleted successfully"
      # render json: { message: 'Album deleted successfully' }, status: :ok
    else
      render json: { error: @album.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
  
  def album_params
    params.permit(:title, :album_image)
  end
  
  def find_album
    begin
      @album = Album.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {error: 'No album found for given id.'}
    end
  end

  # def find_song
  #   begin
  #     @song = Song.find(params[:song_id])
  #   rescue ActiveRecord::RecordNotFound
  #     render json: {error: 'No song found for given id.'}
  #   end
  # end

  def authorize_album_owner
    unless @album.user_id == current_user.id
      render json: { error: 'You are not authorized to perform this action' }, status: :unauthorized
    end
  end

  def validate_artist
    if current_user.user_type != 'Artist'
      render json: { error: 'Listener are Not Allowed for this request' }, status: :forbidden
    end
  end 
end

