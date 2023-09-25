class SongsController < ApplicationController
  before_action :find_song, only: [:update, :destroy, :show]
  before_action :validate_artist, only: [:create]
  before_action :validate_listener, only: [:recently_played_songs]
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
    @current_user.recentyly_playeds.create(song_id: @song.id)
    render json: @song
  end
  
  def index
    songs = Song.paginate(page: params[:page], per_page: 5)
    render json: songs
  end
  
  def update
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
    if params[:query].present?
      query = params[:query]
      songs = Song.where("title LIKE ? OR genre LIKE ?", "%#{query}%", "%#{query}%")
      byebug
      if songs.present?
        render json: {result: songs}
      else
        render json: {result: "No song is available for '#{query}'"}
      end
    else
      render json: {error: "Please enter query to search!"}
    end
  end
  
  def my_top_songs
    songs = @current_user.songs.order(play_count: :desc).limit(3)
    render json: songs, status: 200
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

  def recently_played_songs
    # byebug
    recently_played_songs = @current_user.recentyly_playeds
    if recently_played_songs.present?
      render json: recently_played_song
    else
      render json: { message: "There is no recently played song" }, status: 400
    end
  end

  private
  
  def find_song
    begin
      @song = Song.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {error: 'No record found for given id.'}
    end
  end
  
  def song_owner?(song)
    @song.user_id == @current_user.id
  end
  
  def song_params
    params.permit(:title, :genre, :album_id, :file)
  end

  def validate_artist
    if @current_user.user_type != 'Artist'
      render json: { error: 'Listener are Not Allowed for this request' }, status: :forbidden
    end
  end 

  def validate_listener
    if @current_user.user_type != 'Listener'
      render json: { error: 'Artist are Not Allowed for this request' }, status: :forbidden
    end
  end 
  
end