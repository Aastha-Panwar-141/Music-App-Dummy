class SongsController < ApplicationController
  before_action :find_song, only: [:update, :destroy]
  
  # before_action :authenticate_request
  
  # Add song action
  def create
    # byebug
    song = @current_user.songs.new(song_params)
    if song.save
      render json: { message: 'Song added successfully' }, status: :created
    else
      render json: { error: song.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def show
    @song = Song.find(params[:id])
    render json: {
      user_id: @song.user_id,
      title: @song.title,
      genre: @song.genre,
      album_id: @song.album_id
    }
  end
  
  def index
    @songs = Song.all.map do |song|
      {
        id: song.id,
        user_id: song.user_id,
        title: song.title,
        genre: song.genre,
        album_id: song.album_id
      }
    end
    render json: @songs
  end
  
  def update
    song = Song.find(params[:id])
    if song_owner?(song)
      if song.update(song_params)
        render json: { message: 'Song updated successfully' }
      else
        render json: { error: song.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'You are not authorized to update this song' }, status: :unauthorized
    end
  end
  
  def destroy
    song = Song.find(params[:id])
    if song_owner?(song)
      song.destroy
      render json: { message: 'Song deleted successfully' }
    else
      render json: { error: 'You are not authorized to delete this song' }, status: :unauthorized
    end
  end
  
  def search 
    # byebug
    title = params[:title]
    if title.present?
      songs = Song.where("title LIKE ?", "%#{title}%")
      render json: {result: songs}
    else
      render json: {error: "No record found for given title."}
    end
  end
  
  def search_by_genre
    # byebug
    genre = params[:genre]
    if genre.present?
      songs = Song.where("genre LIKE ?", "%#{genre}%")
      render json: {result: songs}
    else
      render json: {error: "No product is available for this genre."}
    end
  end
  
  private
  
  def find_song
    @song = Song.find(params[:id])
  end
  
  def song_owner?(song)
    @song.user_id == @current_user.id
  end
  
  def song_params
    params.permit(:title, :genre, :album_id, :file)
  end
  
end