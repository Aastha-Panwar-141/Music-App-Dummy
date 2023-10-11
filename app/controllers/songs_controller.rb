class SongsController < ApplicationController
  before_action :find_song, only: [:update, :destroy, :show]
  before_action :validate_artist, only: [:create]
  before_action :validate_listener, only: [:recently_played_songs]
  before_action :check_song_owner, only: [:update, :destroy]
  
  def index
    songs = songs_per_page
    if songs.present?
      if @current_user.user_type == 'Artist'
        followed_ids = @current_user.followers.pluck(:id)
        songs = songs.where(status: 'public').or(songs.where(user_id: followed_ids))
      elsif @current_user.user_type == 'Listener'
        followed_ids = @current_user.followees.pluck(:id)
        songs = songs.where(status: 'public').or(songs.where(user_id: followed_ids))
      end
      render json: songs
    else
      render json: { error: "No songs available!" }, status: :unprocessable_entity
    end
  end
  
  def show
    @song.increment!(:play_count)
    @current_user.recentyly_playeds.create(song_id: @song.id)
  
    if @song.status == 'public' || @current_user.followees.include?(@song.artist)
      render json: @song
    else
      render json: {error: "This is private song, please follow it's artist to listen this song!"}, status: :bad_request
    end
    
  end
  
  def create
    @song = @current_user.songs.new(song_params)
    if @song.save
      @song.file.attach(params[:file])
      render json: { message: 'Song added successfully', song: @song }, status: :created
    else
      render json: { error: @song.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @song.update(song_params)
      render json: { message: 'Song updated successfully' }
    else
      render json: { error: @song.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    byebug
    if @song.destroy
      render json: { message: 'Song deleted successfully' }
    else
      render json: {error: 'Failed to destroy!'}
    end
  end
  
  def songs_per_page
    Song.paginate(page: params[:page], per_page: 5)
  end
  
  def search 
    if params[:query].present?
      query = params[:query]
      songs = Song.where("title LIKE ? OR genre LIKE ?", "%#{query}%", "%#{query}%")
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
    if songs.present?
      render json: songs, status: 200
    else
      render json: {error: "No songs in top played list!"}, status: :unprocessable_entity
    end
  end
  
  def top_10
    top_songs = Song.order(play_count: :desc).limit(10)
    render json: top_songs
  end
  
  def recently_played_songs
    recently_played_songs = @current_user.recentyly_playeds
    if recently_played_songs.present?
      render json: recently_played_songs
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
  
  def check_song_owner
    unless song_owner?(@song)
      render json: {error: "You don't have permission for this action!"}, status: :unprocessable_entity
    end
  end
  
  def song_params
    params.permit(:title, :genre, :album_id, :status, :file)
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