class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :update, :destroy, :add_song]
  before_action :find_song, only: [:add_song]
  before_action :check_playlist_owner, only: [:update, :destroy, :add_song]
  before_action :validate_listener, only: [:create, :add_song, :merge_playlists]
  
  def index
    playlists = Playlist.all
    if playlists.present?
      render json: playlists
    else
      render json: {error: "There is no playlist available!"}, status: :unprocessable_entity
    end
  end
  
  def show
    render json: @playlist
  end
  
  def create
    song_id = params[:song_id]
    unless song_id.present?
      return render json: { error: 'Song is required to create a playlist' }, status: :unprocessable_entity
    end
    @playlist = @current_user.playlists.new(playlist_params)
    if @playlist.save
      song = Song.find_by(song_id)
      if song.present?
        @playlist.songs << song
      else
        render json: {error: "No song is available for given id!"}, status: :unprocessable_entity
      end
      render json: { message: 'Playlist created successfully' }, status: :created
    else
      render json: { error: @playlist.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def update
    if @playlist.update(playlist_params)
      render json: { message: 'Playlist updated successfully' }, status: :ok
    else
      render json: { error: @playlist.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    if @playlist.destroy
      render json: { message: 'Playlist deleted successfully' }, status: :ok
    else
      render json: {error: 'Failed to delete playlist!'}, status: :unprocessable_entity
    end
  end
  
  def add_song
    if @playlist.songs.include?(@song)
      render json: { error: 'Song is already in the playlist' }, status: :unprocessable_entity
    else
      @playlist.songs << @song
      render json: { message: 'Song added to the playlist' }
    end
  end
  
  def merge_playlists
    playlist1_id = params[:playlist1_id]
    playlist2_id = params[:playlist2_id]
    playlist1 = @current_user.playlists.find_by(id: playlist1_id)
    playlist2 = @current_user.playlists.find_by(id: playlist2_id)
    
    unless playlist1.present? && playlist2.present?
      render json: {error: "Playlist not found for given id!"}
    end
    
    merge_title = params[:title]
    
    merged_playlist = @current_user.playlists.create!(title: merge_title)
    merged_songs = (playlist1.songs + playlist2.songs)
    merged_playlist.songs = merged_songs
    if merged_playlist.save
      render json: { message: 'Playlists merged successfully', merged_playlist: merged_playlist }
    else
      render json: { error: 'Failed to merge playlists' }, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_playlist
    unless @playlist = Playlist.find_by_id(params[:id])
      render json: {result: "No playlist found for given id."}
    end
  end
  
  def find_song
    begin
      @song = Song.find(params[:song_id])
    rescue ActiveRecord::RecordNotFound
      render json: {error: 'No song found for given id.'}, status: :unprocessable_entity
    end
  end
  
  def playlist_owner?(playlist)
    @playlist.user_id == @current_user.id
  end
  
  def check_playlist_owner
    unless playlist_owner?(@playlist)
      render json: {error: "You don't have permission for this action!"}, status: :unauthorized
    end
  end
  
  def playlist_params
    params.permit(:title)
  end
  
  # check user-type = Listener
  def validate_listener
    if @current_user.user_type != 'Listener'
      render json: { error: 'Artist are Not Allowed for this request' }, status: :forbidden
    end
  end 
  
end
