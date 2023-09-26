class ArtistsController < ApplicationController
  # view an artist's own songs
  def my_songs
    render json: { songs: @current_user&.songs }  # &.- self navigator
  end
  
    # view an artist's own albums
  def my_albums
    render json: { albums: @current_user&.albums }
  end
end
