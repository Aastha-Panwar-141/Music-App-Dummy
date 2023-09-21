class ArtistsController < ApplicationController

  # view an artist's own songs
  def my_songs
      artist = @current_user
      songs = artist.songs
      render json: {
        songs: songs
      }
    end
  
    # view an artist's own albums
    def my_albums
      artist = @current_user
      albums = artist.albums
      render json: {
        albums: albums,
      }
    end
end
