class AlbumsController < ApplicationController
  before_action :find_album, only: [:update, :destroy]
  before_action :find_song, only: [:add_song]
  before_action :validate_artist

  def index
    album = Album.all
    render json: album
  end
  
  def create
    unless params[:song_id].present?
      return render json: { error: 'Song ID is required to create a album.' }, status: :unprocessable_entity
    end
    song = Song.find_by_id song_id
    album = @current_user.albums.new( album_params) if song.present?
    if album.save
      render json: { message: 'Album created successfully' }, status: :created
    else
      render json: { error: album.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def update
    if album_owner?
      if @album.update(album_params)
        render json: { message: 'Album updated successfully' }
      else
        render json: { error: @album.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'You are not authorized to update this album' }, status: :unauthorized
    end
  end
  
  def destroy
    if album_owner?
      @album.destroy
      render json: { message: 'Album deleted successfully' }
    else
      render json: { error: 'You are not authorized to delete this album' }, status: :unauthorized
    end
  end

  def add_song
    if album_owner?
      byebug
      if @album.songs.include?(@song)
        render json: { error: 'Song is already in the album' }, status: :unprocessable_entity
      else
        @album.songs << @song
        render json: { message: 'Song added to the album' }
      end
    else
      render json: { error: 'You are not authorized to modify this playlist' }, status: :unauthorized
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
      render json: {error: 'No record found for given id.'}
    end
  end

  def find_song
    @song = Song.find(params[:song_id])
  end
  
  def album_owner?
    @album.user_id == @current_user.id
  end

  def validate_artist
    unless @current_user.user_type = 'Artist'
      render json: { error: 'Listener are Not Allowed for this request' }, status: :forbidden
    end
  end 
end

