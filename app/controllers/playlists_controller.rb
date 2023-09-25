class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :update, :destroy, :add_song]
  before_action :find_song, only: [:add_song]
  before_action :validate_listener, only: [:create, :add_song]

  def create
    # byebug
    song_id = params[:song_id]
    unless song_id.present?
      return render json: { error: 'Song ID is required to create a playlist' }, status: :unprocessable_entity
    end
# byebug
    @playlist = @current_user.playlists.new(playlist_params)
    if @playlist.save
      song = Song.find(song_id)
      @playlist.songs << song
      
      render json: { message: 'Playlist created successfully' }, status: :created
    else
      render json: { error: @playlist.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    playlists = Playlist.all
    render json: playlists
  end
  
  def show
    render json: @playlist
  end
  
  def update
    if playlist_owner?
      if @playlist.update(playlist_params)
        render json: { message: 'Playlist updated successfully' }
      else
        render json: { error: @playlist.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'You are not authorized to update this playlist' }, status: :unauthorized
    end
  end
  
  def destroy
    if playlist_owner?
      @playlist.destroy
      render json: { message: 'Playlist deleted successfully' }
    else
      render json: { error: 'You are not authorized to delete this playlist' }, status: :unauthorized
    end
  end

  def add_song
    if playlist_owner?
      if @playlist.songs.include?(@song)
        render json: { error: 'Song is already in the playlist' }, status: :unprocessable_entity
      else
        @playlist.songs << @song
        render json: { message: 'Song added to the playlist' }
      end
    else
      render json: { error: 'You are not authorized to modify this playlist' }, status: :unauthorized
    end
  end

  def merge_playlists
    # byebug
    playlist1_id = params[:playlist1_id]
    playlist2_id = params[:playlist2_id]
    playlist1 = Playlist.find(playlist1_id)
    playlist2 = Playlist.find(playlist2_id)
    if !(playlist1.user_id == @current_user.id && playlist2.user_id == @current_user.id)
      # byebug
      return render json: { error: 'Unauthorized' }, status: :unauthorized
    end
    byebug
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

  #filter to find playlist by it's ID
  def set_playlist
    begin
      @playlist = Playlist.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {result: "No record found for given id."} 
    end
  end
  

  def playlist_params
    params.permit(:title)
    # params.permit(:title, songs:[
    #   :title, :genre, :album_id, :file
    # ])
  end

  def playlist_owner?
    @playlist.user_id == @current_user.id
  end

  # check user-type = Listener
  def validate_listener
    if @current_user.user_type != 'Listener'
      render json: { error: 'You are Not Allowed for this request' }, status: :forbidden
    end
  end 
  
  # filter to find song by ID
  def find_song
    @song = Song.find(params[:song_id])
  end

end
