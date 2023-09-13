class ArtistsController < ApplicationController
    skip_before_action :authenticate_request, only: [:create]
    before_action :set_artist, only: [:show, :destroy, :update]
        
    # GET /artists
    def index
        artists = Artist.all
        render json: artists, status: :ok
    end
    
    # GET /artists/{artistname}
    def show
        render json: @artist, status: :ok
    end
    
    # POST /artists
    def create
        artist = Artist.new(artist_params)
        if artist.save
            render json: artist, status: :created
        else
            render json: { errors: artist.errors.full_messages },
            status: :unprocessable_entity
        end
    end
    
    # PUT /artists/{artistname}
    def update
        unless @artist.update(artist_params)
            render json: { errors: @artist.errors.full_messages },
            status: :unprocessable_entity
        end
    end
    
    # DELETE /artists/{artistname}
    def destroy
        @artist.destroy
    end
    
    private
    
    def set_artist
        @artist = Artist.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { errors: 'artist not found' }, status: :not_found
    end
    
    def artist_params
        params.permit(
            :artistname, :email, :password
        )
    end
end
