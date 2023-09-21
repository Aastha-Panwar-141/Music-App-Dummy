class SongsController < ApplicationController
  before_action :find_song, only: [:update, :destroy, :show]
  
  # before_action :authenticate_request
  
  def create
    # byebug
    song = @current_user.songs.new(song_params)
    if song.save
      song.file.attach(params[:file])
      render json: { message: 'Song added successfully', song: song }, status: :created
    else
      render json: { error: song.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def show
    @song.increment!(:play_count)
    render json: @song
  end
  
  def index
    songs = Song.all
    render json: songs
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

  def top_played_songs
    # byebug
    user_id = @current_user.id  
    top_songs = Song.where(user_id: user_id).order(play_count: :desc).limit(10)
    render json: top_songs
  end

  def top_10
    top_songs = Song.order(play_count: :desc).limit(10)
    render json: top_songs
  end
  
  def recommended_by_genre
    genre = params[:genre]
    recommended_tracks = Song.where(genre: genre).order(play_count: :desc).limit(10)
    render json: recommended_tracks, status: :ok
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