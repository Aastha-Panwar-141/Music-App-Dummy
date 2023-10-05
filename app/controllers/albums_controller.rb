class AlbumsController < ApplicationController
  before_action :find_album, only: [:update, :destroy]
  before_action :find_song, only: [:add_song]
  before_action :validate_artist
  before_action :authorize_album_owner, only: [:update, :destroy, :add_song]

  def index
    albums = Album.all
    if albums.present?
      render json: albums
    else
      render json: {error: "There is no album present!"}
    end
  end

  # def create
  #   # byebug
  #   song_id = params[:song_id]
  #   unless song_id.present?
  #     return render json: { error: 'Song ID is required to create a album' }, status: :unprocessable_entity
  #   end
  #   @album = @current_user.albums.new(album_params)
  #   if @album.save
  #     song = Song.find(song_id)
  #     @album.songs << song
      
  #     render json: { message: 'Album created successfully' }, status: :created
  #   else
  #     render json: { error: @album.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end
  
  # def create
  #   unless params[:song_id].present?
  #     return render json: { error: 'Song ID is required to create a album.' }, status: :unprocessable_entity
  #   end
  #   song_id = Song.find_by_id(params[:song_id])
  #   if song_id.nil?
  #     return render json: { error: 'Song not found with the given ID' }, status: :not_found
  #   end
  #   @album = @current_user.albums.new(album_params)
  #   if @album.save
  #     song = Song.find(song_id)
  #     @album.songs << song
  #     render json: { message: 'Album created successfully' }, status: :created
  #   else
  #     render json: { error: @album.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

  def update
    if @album.update(album_params)
      render json: { message: 'Album updated successfully' }
    else
      render json: { error: @album.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @album.destroy
      render json: { message: 'Album deleted successfully' }
    else
      render json: { error: @album.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def add_song
    if @album.songs.include?(@song)
      render json: { error: 'Song is already in the album' }, status: :unprocessable_entity
    else
      @album.songs << @song
      render json: { message: 'Song added to the album' }, status: :ok
    end
  end
  
  private
  
  def album_params
    params.permit(:title)
  end
  
  def find_album
    begin
      @album = Album.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {error: 'No album found for given id.'}
    end
  end

  def find_song
    begin
      @song = Song.find(params[:song_id])
    rescue ActiveRecord::RecordNotFound
      render json: {error: 'No song found for given id.'}
    end
  end

  def authorize_album_owner
    # byebug
    unless @album.user_id == @current_user.id
      render json: { error: 'You are not authorized to perform this action' }, status: :unauthorized
    end
  end

  def validate_artist
    # byebug
    if @current_user.user_type != 'Artist'
      render json: { error: 'Listener are Not Allowed for this request' }, status: :forbidden
    end
  end 
end

