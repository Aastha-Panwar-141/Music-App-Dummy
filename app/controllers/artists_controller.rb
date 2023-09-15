class ArtistsController < ApplicationController
  skip_before_action :authenticate_request, only: [ :create]
  # before_action :authenticate_request, except: [:index, :create]
  before_action :set_artist, only: [:show, :destroy, :update]
  
  # GET /artists
  def index
      artists = Artist.all
      render json: artists, status: :ok
  end
  
  # GET /artists/1
  def show
    render json: @artist, status: :ok
  end
  
  # POST /artists
  def create
    artist = Artist.new(artist_params)
    if artist.save
      render json: {message: 'Artist created.', created_record: artist}, status: :created
    else
      render json: { errors: artist.errors.full_messages },
      status: :unprocessable_entity
    end
  end
  
  # PUT /artists/1
  def update
    if @artist.update(artist_params)
      render json: {message: 'Artist updated', updated_record: @artist}
    else
      render json: {errors: @artist.errors}, status: :unprocessable_entity
    end
  end
  
  # DELETE /artists/1
  def destroy
    # byebug
    if @artist.destroy
      render json: { message: 'Artist deleted', deleted_record: @artist }
    else
      render json: { message: 'Artist deletion failed' }
    end
  end

  # def add_song
  #   song = Song.new(song_params)
  #   if song.save
  #     render json: {message: 'Song created.', created_record: song}, status: :created
  #   else
  #     render json: { errors: song.errors.messages },
  #     status: :unprocessable_entity
  #   end
  # end

  def update_password
  end

  def top_song
  end

  def update_song
  end

  def albums
  end


  
  
  private
  
  def set_artist
    # byebug
    @artist = Artist.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Artist not found' }, status: :not_found
  end
  
  def artist_params
    params.permit(
      :username, :email, :password
    )
  end

  # def song_params
  #   params.permit(
  #     :title, :genre, :artist_id
  #   )
  # end
end
