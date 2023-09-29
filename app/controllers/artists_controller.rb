class ArtistsController < ApplicationController
  # view an artist's own songs
  def my_songs
    render json: @current_user&.songs  # &.- self navigator
  end
  
    # view an artist's own albums
  def my_albums
    render json: @current_user&.albums
  end
end
