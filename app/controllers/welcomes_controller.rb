class WelcomesController < ApplicationController
  # skip_before_action :authenticate_request
  
  def index
    @songs = Song.limit(5)
    @playlists = Playlist.limit(5)
    @albums = Album.limit(5)
  end
end
